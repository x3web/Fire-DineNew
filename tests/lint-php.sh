#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
while IFS= read -r -d '' file; do php -l "$file" >/dev/null; done < <(find "$root" -path "$root/vendor" -prune -o -name '*.php' -type f -print0)
echo "PHP syntax lint passed."
