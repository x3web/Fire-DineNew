# Fire & Dine installation package

Status: **UNRELEASED — runtime verification required**  
Build date: **23 August 2026**  
Supported database: **MariaDB 10.11**

This single package contains the PHP application, public web root, approved catalogue, quote and contact-enquiry systems, authenticated administration, public product API, clean-install SQL, ordered upgrade migrations, verification queries, automated test definitions, environment templates and server configuration examples.

Do not label or deploy it as `v1.0.0` until every command in `docs/INSTALLATION-GUIDE.md` and the release gate in `tests/run-database-gate.sh` passes on the target stack.

## Start here

1. Read `docs/INSTALLATION-GUIDE.md`.
2. Point the web server document root to `public/` only.
3. Copy `.env.example` to `.env` and replace every placeholder.
4. Import `database/install/Fire-And-Dine-Clean-Install.sql` into a new MariaDB database, or run `php bin/migrate.php` against a backed-up original 22 August database.
5. Run `php bin/create-admin.php admin@example.com FirstName LastName`.
6. Run the SQL, PHPUnit and Playwright release gates before deployment.

## Active routes

- Public: `/`, `/about`, `/shop`, `/category/{parent}`, `/category/{parent}/{child}`, `/product/{slug}`, `/installation`, `/gallery`, `/contact`, `/faq`, `/cart`, `/checkout`, `/privacy-policy`, `/terms-of-service`, `/brochure/{id}`.
- SEO: `/sitemap.xml`, `/robots.txt`.
- API: documented in `docs/API-CONTRACT.md`.
- Admin: `/admin`, `/admin/product`, `/admin/categories`, `/admin/quotes`, `/admin/quote`, `/admin/enquiries`, `/admin/enquiry`, `/admin/confirmations`, `/admin/confirmation`, `/admin/recaptcha`, `/admin/logout`.

Unknown prices remain `NULL` and display as “Request a quote” or “Price pending”; they never display as R0. Tax is configurable through `settings.quote_tax_enabled` and `settings.quote_tax_rate` and is disabled by default. Delivery and installation are quoted separately. Products 83 and 106 remain archived and hidden, Product 98 relates to the Rib Rack, and Product 104 remains out of stock.
