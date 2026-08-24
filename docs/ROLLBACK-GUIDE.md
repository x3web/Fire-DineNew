# Rollback guide

Before any upgrade, take a full logical database dump, a storage snapshot and an atomic copy of the currently deployed application. Restore each backup to a separate test location and verify it before proceeding.

If a migration, test or production health check fails:

1. Stop writes and remove the new deployment from public traffic.
2. Preserve application, web-server, PHP-FPM, SMTP and MariaDB logs privately.
3. Restore the complete pre-upgrade database backup. Do not attempt to reverse the migrations manually.
4. Restore the prior application directory atomically and its matching `.env` and uploaded media.
5. Clear PHP opcode, reverse-proxy and CDN caches.
6. Verify the prior `/api/health`, public routes, admin login and quote path.
7. Reopen traffic only after the prior version is healthy.

The migration runner never modifies the application files. `schema_migrations` records successful SQL files and their checksums, but it is not a substitute for a verified database backup.

The final correction migration adds quote/enquiry fields and logs, category redirect paths, protected catalogue corrections and disabled tax settings. It has no safe standalone down migration because production quote/enquiry data may use the new schema. Restore the verified pre-upgrade database and matching application together.
