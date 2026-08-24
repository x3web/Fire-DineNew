# Security and quality report

Status: **source corrections implemented; runtime verification not executed in this build environment**

Implemented controls include server-authoritative pricing, prepared PDO queries, explicit public-field whitelists, active/visible filtering, stock validation, CSRF for quote/enquiry/admin writes, honeypots, optional fail-closed CAPTCHA, database rate limits with 429/`Retry-After`, input bounds, post-commit quote references, idempotency, SMTP TLS, email result logging, secure sessions with idle/absolute expiry, account role/status/session-version revalidation, POST logout, hidden terminal password input, `Cache-Control: no-store` on all admin HTML/JSON responses, private exception logs, upload/private-path denial, controlled PDF streaming, a query-preserving legacy brochure redirect, nonce-based CSP, slug redirects and admin audit records.

The clean SQL removes operational/test/customer/session/token/log data and legacy/raw staging tables. Unknown catalogue prices remain `NULL`; no unknown amount is represented as zero. The upgrade path preserves operational records.

The executable test definitions cover MariaDB clean import and original upgrade, second-run idempotence, exact prices, repository filters, configurable tax on/off, quote commit/rollback/idempotency/email content/logs/admin detail, enquiry persistence/detail/status/delivery diagnostics, API methods and the legacy brochure redirect, CSRF/traversal/tampering paths, mandatory isolated-admin browser journeys, all public routes and same-origin links/assets/CSS/gallery files, accessibility and Chromium/Firefox/WebKit layouts.

The current container has no PHP executable, MariaDB server/client, Composer executable or installed browser binaries. Therefore no claim is made that these controls have passed dynamically here, and this package must not be promoted to `v1.0.0` until the target-host gate passes. See `docs/AUTOMATED-TEST-RESULTS.md`.
