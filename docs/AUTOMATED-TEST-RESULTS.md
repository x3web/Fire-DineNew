# Automated test results

Build: **UNRELEASED — live-server verification pending**  
Date: **23 August 2026**

## Completed locally

| Check | Result |
|---|---|
| JavaScript syntax for all packaged JavaScript | PASS |
| Node basket regression tests, including quantity 60 + 60 = 99 with 99-unit totals | PASS — 2/2 |
| Shell-script syntax | PASS |
| JSON validity for Composer and npm manifests | PASS |
| Conservative PHP delimiter/string structure scan | PASS — 27 PHP files |
| Static SQL quote/comment/parenthesis inspection | PASS |
| Migration SHA-256 verification against the clean-install ledger | PASS |
| Approved clean-install SQL and all migrations compared with the previously verified package | PASS — byte-for-byte unchanged |
| Duplicate base catalogue ID, slug and SKU inspection | PASS |
| Product Guide category and exact price mapping comparison | PASS |
| Active PHP/JavaScript/CSS local-asset and case-sensitive existence scan | PASS |
| Exact broken-gallery filename search and no-substitute handling | PASS |
| Hardcoded credential/private-key/token scan | PASS |
| Clean-install operational/customer/test-data scan | PASS |
| Hardcoded 15% quote VAT calculation removal search | PASS |
| Explicit API whitelist and recursive internal-field filtering search | PASS |
| Follow-up release-source checks: corrected SQL column/slug assertions, mandatory admin credentials, internal-only admin quote URL, legacy redirect, complete enquiry diagnostics and admin no-store headers | PASS |
| Final ZIP integrity, unsafe paths and clean-extraction source comparison | PASS |

## Pending because the required local runtime is unavailable

| Check | Status |
|---|---|
| Native PHP `php -l` | PENDING — PHP executable unavailable |
| PHPUnit | PENDING — PHP/Composer dependencies unavailable |
| MariaDB clean import and verification SQL | PENDING — MariaDB server/client unavailable |
| Upgrade execution and second-run database idempotence | PENDING — PHP/MariaDB unavailable |
| Playwright browser suite | PENDING — PHP server, installed Playwright dependencies and browser binaries unavailable |

No runtime, database, live-email or browser pass is claimed. The implemented test commands and safeguards are in `INSTALLATION-GUIDE.md`, `tests/lint-php.sh`, `tests/run-database-gate.sh`, `phpunit.xml` and `playwright.config.js`.
