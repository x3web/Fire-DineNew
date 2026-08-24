# Active API contract

All JSON errors use `{"error":{"message":"…","status":NNN}}`. Unsupported methods return 405 with `Allow`. JSON request bodies are limited to 1 MiB. Public write routes are rate-limited; 429 responses include `Retry-After`.

| Method | Route | Inputs | Response |
|---|---|---|---|
| GET | `/api/health` | none | Database health, application marker and migration marker. |
| GET | `/api/categories` | none | Active two-level category tree. |
| GET | `/api/products` | `q` max 100 chars; `featured` boolean; `category`; `subcategory`; `page`; `per_page` capped at 48 | Explicitly whitelisted active/visible product summaries plus pagination. Invalid parent-child category combinations return 404. |
| GET | `/api/product` | required `slug` | Explicitly whitelisted public product, active variations and availability, safe options, related price ranges and ordered gallery. Nested data is recursively sanitized. |
| POST | `/api/configuration-price` | CSRF header/token; `product_id`; optional `variation_id`; `option_value_ids`; `quantity` 1–99 | Server-calculated confirmed unit/line prices and custom-quote state. Browser price fields are ignored. |
| GET | `/api/quotes` | none | Session CSRF token, one-use-style idempotency key and optional CAPTCHA site key. |
| POST | `/api/quotes` | CSRF; idempotency key; CAPTCHA token when enabled; customer/address fields; 1–50 basket lines | 201 quote reference after commit, confirmed amounts, pending-price components and pricing status. Duplicate keys return the original reference. Tax is applied only when the optional database setting is enabled; it is disabled by default. |
| POST | `/api/enquiries` | CSRF; honeypot; CAPTCHA when enabled; required name/email/phone/message and optional product/location fields | 201 receipt confirmation after the enquiry is committed. Email failure is logged and does not delete the enquiry. |
| GET | `/api/recaptcha-public` | none | CAPTCHA enabled flag and public site key only. |
| GET | `/api/tracking-config` | none | Approved public analytics identifiers or null. |
| POST | `/api/tracking-event` | validated `event_name`, optional page/source | 202 accepted; stores only the allowed payload subset. |
| GET | `/api/brochure?id={id}` | enabled brochure ID | Controlled PDF stream or 404. Legacy `/api/brochure.php?id={id}` returns a 301 redirect to this route with the encoded `id` retained; `/brochure/{id}` is the preferred public URL. |
| GET | `/admin/recaptcha` | authenticated admin session | Enabled flag and public site key. |
| POST | `/admin/recaptcha` | authenticated admin session and CSRF | Confirms that secrets must be managed in the private environment file. |

State-changing quote/enquiry calls require the CSRF token obtained from GET `/api/quotes`. CAPTCHA configuration is server-validated. Public product responses are built from an explicit field whitelist and recursively exclude `legacy_label`, confirmation/provisional data, internal notes, migration/import/source information and administrative metadata. Brochure responses stream only enabled database records whose normalized local PDF path exists beneath the approved brochure directory; invalid, disabled, missing and traversal targets return 404. Every authenticated or unauthenticated admin HTML/JSON response sends `Cache-Control: no-store`.
