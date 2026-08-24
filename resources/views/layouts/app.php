<!DOCTYPE html>
<html lang="en"><head><?php require dirname(__DIR__) . '/partials/meta.php'; ?></head><body<?= $bodyAttributes ?? '' ?>><?php require dirname(__DIR__) . '/partials/header.php'; ?><?= $main ?? '' ?><?php require dirname(__DIR__) . '/partials/footer.php'; ?><?php require dirname(__DIR__) . '/partials/scripts.php'; ?></body></html>
