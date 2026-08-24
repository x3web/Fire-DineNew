#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
test_env="$root/.env.test"
[[ -f "$test_env" ]] || { echo 'Missing .env.test. Copy .env.test.example and configure dedicated test credentials.' >&2; exit 1; }

while IFS='=' read -r key value; do
  [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
  [[ -n "$key" && ! "$key" =~ ^[[:space:]]*# ]] || continue
  value="${value%\"}"; value="${value#\"}"; value="${value%\'}"; value="${value#\'}"
  export "$key=$value"
done < "$test_env"

for key in TEST_DB_HOST TEST_DB_PORT TEST_DB_USERNAME TEST_DB_PASSWORD TEST_CLEAN_DB_DATABASE TEST_UPGRADE_DB_DATABASE; do
  [[ -n "${!key+x}" ]] || { echo "Missing required test credential: $key" >&2; exit 1; }
done

clean_db="$TEST_CLEAN_DB_DATABASE"
upgrade_db="$TEST_UPGRADE_DB_DATABASE"
for db in "$clean_db" "$upgrade_db"; do
  [[ "$db" =~ ^[A-Za-z0-9_]+_test$ ]] || { echo "Refusing unsafe test database name: $db" >&2; exit 1; }
done

client="${MARIADB_BIN:-mariadb}"
dump_bin="${MARIADB_DUMP_BIN:-mariadb-dump}"
host="$TEST_DB_HOST"; port="$TEST_DB_PORT"; user="$TEST_DB_USERNAME"; export MYSQL_PWD="$TEST_DB_PASSWORD"
sql=("$client" "--host=$host" "--port=$port" "--user=$user" "--default-character-set=utf8mb4" "--binary-mode=1")
gate_tmp="$(mktemp -d "${TMPDIR:-/tmp}/fire-dine-gate.XXXXXXXX")"
trap 'rm -rf -- "$gate_tmp"' EXIT

"${sql[@]}" -e "DROP DATABASE IF EXISTS \`$clean_db\`; CREATE DATABASE \`$clean_db\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
"${sql[@]}" "$clean_db" < "$root/database/install/Fire-And-Dine-Clean-Install.sql"
"${sql[@]}" --skip-column-names "$clean_db" < "$root/database/verify_release_corrections.sql" | tee "$gate_tmp/clean-release-corrections.txt"
"${sql[@]}" --skip-column-names "$clean_db" < "$root/database/verify_release_gate_fixes.sql" | tee "$gate_tmp/clean-release-gate-fixes.txt"
! grep -q FAIL "$gate_tmp/clean-release-corrections.txt" "$gate_tmp/clean-release-gate-fixes.txt"

[[ -n "${ORIGINAL_DATABASE_SQL:-}" && -f "${ORIGINAL_DATABASE_SQL:-}" ]] || { echo 'Set ORIGINAL_DATABASE_SQL to the untouched 22 August SQL dump.' >&2; exit 1; }
"${sql[@]}" -e "DROP DATABASE IF EXISTS \`$upgrade_db\`; CREATE DATABASE \`$upgrade_db\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
"${sql[@]}" "$upgrade_db" < "$ORIGINAL_DATABASE_SQL"
FIRE_DINE_ENV_FILE="$test_env" DB_DATABASE="$upgrade_db" php "$root/bin/migrate.php"
tables='categories products product_variations product_option_groups product_option_values product_related_products product_media'
MYSQL_PWD="$TEST_DB_PASSWORD" "$dump_bin" --host="$host" --port="$port" --user="$user" --skip-comments --compact --skip-extended-insert "$upgrade_db" $tables | sha256sum > "$gate_tmp/before-second.sha256"
FIRE_DINE_ENV_FILE="$test_env" DB_DATABASE="$upgrade_db" php "$root/bin/migrate.php"
MYSQL_PWD="$TEST_DB_PASSWORD" "$dump_bin" --host="$host" --port="$port" --user="$user" --skip-comments --compact --skip-extended-insert "$upgrade_db" $tables | sha256sum > "$gate_tmp/after-second.sha256"
cmp "$gate_tmp/before-second.sha256" "$gate_tmp/after-second.sha256"
"${sql[@]}" --skip-column-names "$upgrade_db" < "$root/database/verify_release_corrections.sql" | tee "$gate_tmp/upgrade-release-corrections.txt"
"${sql[@]}" --skip-column-names "$upgrade_db" < "$root/database/verify_release_gate_fixes.sql" | tee "$gate_tmp/upgrade-release-gate-fixes.txt"
! grep -q FAIL "$gate_tmp/upgrade-release-corrections.txt" "$gate_tmp/upgrade-release-gate-fixes.txt"
echo 'Clean import, original upgrade, idempotence and release-gate verification passed.'
