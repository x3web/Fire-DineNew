const { spawnSync } = require('node:child_process');
const path = require('node:path');

module.exports = async () => {
  const root = path.resolve(__dirname, '../..');
  const result = spawnSync(
    process.env.PHP_BINARY || 'php',
    ['tests/browser/cleanup-test-run.php', process.env.TEST_ADMIN_EMAIL],
    { cwd: root, env: process.env, encoding: 'utf8', windowsHide: true }
  );
  if (result.error) throw new Error(`Unable to clean the isolated browser-test records: ${result.error.message}`);
  if (result.status !== 0) throw new Error(`Unable to clean the isolated browser-test records. ${result.stderr || result.stdout}`.trim());
};
