# Changelog

## Unreleased verification build — 23 August 2026

- Fixed transactional quote submission with named parameters, server repricing, idempotency, variation SKUs, selected-option snapshots, custom-price state and post-commit email logging.
- Added quote administration, status history and customer/contact search.
- Restored complete public routes, catalogue hierarchy, product galleries, structured specifications, installation/curing guidance, enquiry handling and controlled brochure downloads.
- Added the required public/admin APIs, explicit public product fields, bounded pagination, consistent errors and method handling.
- Added selectable Steel colours, corrected Mobile Countertop related products, Canvas variation price ranges and out-of-stock behaviour.
- Completed variation/option/media/category administration validation, deactivation, ordering, conditions, metadata, slug redirects and audit writes.
- Added CSRF, honeypot, CAPTCHA, rate-limit, session-expiry, admin revalidation, POST logout, runtime logging and nonce-based Content Security Policy controls.
- Added MariaDB migration history, SHA-256 checksums, advisory locking and an exact release verifier.
- Added clean-install sanitisation and removed archived FLINT brochure files from the public package.
- Replaced token-search checks with executable PHPUnit, MariaDB and Playwright release-gate suites.
- Added `20260823_fire_dine_release_gate_fixes.sql` without changing any earlier checksummed migration and mirrored its final state into the clean installer and checksum ledger.
- Removed automatic 15% VAT, added optional tax settings disabled by default, and retained Product Guide prices with delivery and installation separate.
- Completed quote configuration snapshots, pending-price components, administration, status history and detailed customer/business email content.
- Completed persisted enquiry handling, failure-safe email logging, protected enquiry administration and regression coverage.
- Corrected installation, curing, airflow, cleaning and damper guidance; restored exact supplied assets; disabled unrecoverable gallery references without substitutes.
- Added capped basket merge recalculation, protected category topology/redirects, 404 category-pair handling and recursive public API sanitization.
- Made PHP, database-gate and browser test configuration `.env.test`-only with guarded test database names and non-predictable temporary directories.
- Corrected the release-gate catalogue tests to use `products.regular_price`, `product_option_values.price_adjustment` and the canonical `premium-diy-range` slug.
- Added an absolute, safely configured admin quote link to the internal email only, plus tax, email-content and admin quote-detail regression coverage.
- Made browser-admin testing mandatory with disposable-database administrator setup and cleanup; added full public-route/link/asset/CSS/gallery crawling.
- Made the legacy brochure endpoint a query-preserving 301 redirect in PHP, Apache and Nginx.
- Completed escaped enquiry details and delivery diagnostics, tested status updates, hid interactive admin passwords and disabled caching for all admin HTML/JSON responses.

This build is deliberately not called `v1.0.0`; its PHP/MariaDB/browser runtime gate has not been executed in the build environment.
