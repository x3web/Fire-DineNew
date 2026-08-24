const { defineConfig, devices } = require('@playwright/test');
const fs = require('node:fs');
const path = require('node:path');

const testEnvironment = path.join(__dirname, '.env.test');
if (!fs.existsSync(testEnvironment)) throw new Error('Missing .env.test. Copy .env.test.example and configure dedicated test credentials. Playwright never loads the normal .env.');
for (const rawLine of fs.readFileSync(testEnvironment, 'utf8').split(/\r?\n/)) {
  const line = rawLine.trim();
  if (!line || line.startsWith('#')) continue;
  const separator = line.indexOf('=');
  if (separator < 1) continue;
  const key = line.slice(0, separator).trim();
  let value = line.slice(separator + 1).trim();
  if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) value = value.slice(1, -1);
  process.env[key] = value;
}
for (const key of ['DB_HOST','DB_PORT','DB_DATABASE','DB_USERNAME','DB_PASSWORD']) if (!(key in process.env)) throw new Error(`Missing required test credential: ${key}. Configure it explicitly in .env.test.`);
for (const key of ['TEST_ADMIN_EMAIL','TEST_ADMIN_PASSWORD']) if (!(key in process.env) || process.env[key] === '') throw new Error(`Missing required test credential: ${key}. Configure it explicitly in .env.test.`);
if (!/^[A-Za-z0-9_]+_test$/.test(process.env.DB_DATABASE)) throw new Error('Unsafe DB_DATABASE for browser tests. The name must match ^[A-Za-z0-9_]+_test$.');
if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(process.env.TEST_ADMIN_EMAIL)) throw new Error('TEST_ADMIN_EMAIL must be a valid dedicated test address.');
if (process.env.TEST_ADMIN_PASSWORD.length < 12) throw new Error('TEST_ADMIN_PASSWORD must contain at least 12 characters.');
process.env.FIRE_DINE_ENV_FILE = testEnvironment;

module.exports = defineConfig({
  testDir: './tests/browser',
  globalSetup: require.resolve('./tests/browser/global-setup.js'),
  globalTeardown: require.resolve('./tests/browser/global-teardown.js'),
  fullyParallel: false,
  timeout: 30000,
  use: { baseURL: process.env.TEST_BASE_URL || 'http://127.0.0.1:8080', trace: 'retain-on-failure' },
  projects: [
    { name: 'chromium-320', use: { ...devices['Desktop Chrome'], viewport: { width: 320, height: 900 } } },
    { name: 'chromium-375', use: { ...devices['Desktop Chrome'], viewport: { width: 375, height: 900 } } },
    { name: 'chromium-768', use: { ...devices['Desktop Chrome'], viewport: { width: 768, height: 1024 } } },
    { name: 'chromium-1024', use: { ...devices['Desktop Chrome'], viewport: { width: 1024, height: 900 } } },
    { name: 'chromium-1366', use: { ...devices['Desktop Chrome'], viewport: { width: 1366, height: 900 } } },
    { name: 'chromium-1920', use: { ...devices['Desktop Chrome'], viewport: { width: 1920, height: 1080 } } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } }
  ],
  webServer: process.env.TEST_EXTERNAL_SERVER ? undefined : {
    command: 'php -S 127.0.0.1:8080 -t public tests/router.php',
    url: 'http://127.0.0.1:8080/api/health',
    reuseExistingServer: false,
    timeout: 30000
  }
});
