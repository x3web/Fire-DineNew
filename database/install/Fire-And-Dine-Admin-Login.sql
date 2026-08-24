-- Fire & Dine administrator account supplied for this deployment.
-- Safe to import again: the existing account is updated, not duplicated.
INSERT INTO `users`
  (`first_name`,`last_name`,`email`,`password_hash`,`role`,`status`,`must_change_password`,`session_version`,`password_changed_at`)
VALUES
  ('Fire & Dine','Administrator','info@fireanddine.co.za','$2y$12$XI6zEi7itoMi24oLMmce0O3AsXrsDkYWYxskfRWEvyf3HXV04I/AK','super_admin','active',0,1,NOW())
ON DUPLICATE KEY UPDATE
  `first_name`=VALUES(`first_name`),
  `last_name`=VALUES(`last_name`),
  `password_hash`=VALUES(`password_hash`),
  `role`='super_admin',
  `status`='active',
  `must_change_password`=0,
  `failed_login_attempts`=0,
  `locked_until`=NULL,
  `password_changed_at`=NOW(),
  `session_version`=`session_version`+1;
