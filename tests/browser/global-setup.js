const { spawnSync } = require('node:child_process');
const path = require('node:path');

module.exports = async () => {
  const root = path.resolve(__dirname, '../..');
  const result = spawnSync(
    process.env.PHP_BINARY || 'php',
    ['bin/create-admin.php', process.env.TEST_ADMIN_EMAIL, 'Browser', 'Test Administrator'],
    {
      cwd: root,
      env: process.env,
      input: `${process.env.TEST_ADMIN_PASSWORD}\n`,
      encoding: 'utf8',
      windowsHide: true
    }
  );
  if (result.error) throw new Error(`Unable to create the isolated browser-test administrator: ${result.error.message}`);
  if (result.status !== 0) throw new Error(`Unable to create the isolated browser-test administrator. ${result.stderr || result.stdout}`.trim());
};
