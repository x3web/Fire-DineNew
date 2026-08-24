# Fire & Dine installation guide

Status: **verification required before deployment**

## 1. Requirements

- Linux, HTTPS and either Apache 2.4 or Nginx.
- PHP 8.1+ with `pdo_mysql`, `json`, `filter`, `session`, `fileinfo`, `openssl` and `mbstring`.
- MariaDB 10.11 server and client tools (`mariadb`, `mariadb-dump`). MySQL compatibility is not claimed.
- Composer 2 and Node.js 20+ are required for the test gate; production runtime has no third-party package dependency.
- SMTP with TLS for production email.

## 2. Files and configuration

Extract the ZIP into a new private directory. The only web-accessible directory is `public/`. Never copy `.env`, `database/`, `src/`, `tests/`, `storage/`, `vendor/` or `bin/` beneath another public root.

Copy `.env.example` to `.env`. Set the canonical HTTPS `APP_URL`, a unique `APP_KEY` of at least 32 random characters, least-privilege database credentials, secure-session settings, SMTP credentials and the quote-notification address. Generate a key with:

```bash
php -r "echo bin2hex(random_bytes(32)), PHP_EOL;"
```

Use `MAIL_TRANSPORT=smtp`, `MAIL_ENCRYPTION=tls` or `ssl`, and authenticated SMTP. `MAIL_TRANSPORT=log` is only for tests. CAPTCHA is optional, but if either CAPTCHA key is set then both must be valid; a mismatch fails closed.

Make `storage/logs/` writable by PHP. Keep the rest of the application read-only to the web account. Never use world-writable permissions.

## 3. Clean installation

Create a completely empty UTF-8 database and import:

```bash
mariadb --host=HOST --user=USER --password DATABASE < database/install/Fire-And-Dine-Clean-Install.sql
```

The clean SQL contains catalogue, media, settings and required reference data only. It excludes users, customers, quotes, enquiries, orders, sessions, tokens, rate-limit rows, test email logs and development security events. Maintenance mode starts disabled. It records the included migration checksums.

Tax is optional and disabled by default through the `settings` rows `quote_tax_enabled=0` and `quote_tax_rate=0`. Leave it disabled until Fire & Dine confirms its VAT policy. With tax disabled, confirmed Product Guide prices are used unchanged; delivery and installation remain quoted separately.

Create the mandatory first administrator; the password is read from standard input and is not placed in shell history:

```bash
php bin/create-admin.php admin@example.com FirstName LastName
```

## 4. Upgrade from the original 22 August database

Take and verify a full database and application backup first. Configure `.env` for the backed-up staging copy, then run:

```bash
php bin/migrate.php
```

The runner acquires a MariaDB advisory lock, creates `schema_migrations`, checks SHA-256 checksums, applies each pending SQL file in filename order—including `20260823_fire_dine_release_gate_fixes.sql`—records only successful migrations and refuses a changed already-applied migration. A second run must report every migration as skipped. Never import the clean-install SQL over a live database.

## 5. Web server

Use `docs/apache-vhost.conf` or `docs/nginx-server.conf` as the starting point and replace all example paths/domains. For Apache, enable `rewrite`, `headers` and PHP-FPM integration. For Nginx, use PHP-FPM and keep the project root outside the document root.

## 6. Reproducible release gate

Create `.env.test` from `.env.test.example`; PHP, database-gate and Playwright tests explicitly load only that file and never the normal `.env`. Set dedicated `TEST_ADMIN_EMAIL` and `TEST_ADMIN_PASSWORD` values. Playwright fails when either is missing, creates that isolated administrator in the disposable `DB_DATABASE` before the browser suite and removes the administrator and run-generated operational records afterward. All destructive test database names must match `^[A-Za-z0-9_]+_test$`; the test tools abort on missing credentials or unsafe names. Provide the untouched original SQL dump in `ORIGINAL_DATABASE_SQL`.

```bash
composer install
npm install
npx playwright install --with-deps chromium firefox webkit
chmod +x tests/*.sh bin/*.php
tests/lint-php.sh
ORIGINAL_DATABASE_SQL=/private/path/fireanddine-22.08.sql tests/run-database-gate.sh
vendor/bin/phpunit --configuration phpunit.xml
npm test
```

Then run `database/verify_release_corrections.sql` and `database/verify_release_gate_fixes.sql` against both clean and upgraded databases; every row must be `PASS`. Check `/api/health`, all public/admin/API routes, every valid and invalid configuration, quote and enquiry success/failure logs, the legacy brochure redirect and controlled download, hidden URLs, keyboard navigation and the browser projects at 320, 375, 768, 1024, 1366 and 1920 widths. The Playwright matrix covers Chromium, Firefox and WebKit (Safari-compatible engine). Its public crawl follows every same-origin public page and validates links, scripts, stylesheets, images, fonts, downloads, CSS `url(...)` references and rendered enabled gallery media.

Do not deploy if any PHP, SQL, JavaScript, link, asset, browser, accessibility or application-log error remains. Record the target-host results in `docs/AUTOMATED-TEST-RESULTS.md` before changing the version to `v1.0.0`.

## 7. Operational checks

- Confirm HTTPS, HSTS and secure cookies.
- Confirm `.env`, source, migrations and logs cannot be downloaded.
- Confirm SMTP actually delivers to controlled business/customer addresses and a forced failure is logged without deleting the quote.
- Confirm CAPTCHA succeeds on the production domain if configured.
- Confirm no public price is zero, custom amounts remain pending, and delivery/installation are separate.
- Confirm Product 83 and FLINT 1 return 404 publicly.
- Confirm `/sitemap.xml` contains only active public clean URLs.

For failure recovery, follow `docs/ROLLBACK-GUIDE.md`.
