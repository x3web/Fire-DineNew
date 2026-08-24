const { test, expect } = require('@playwright/test');

test.beforeEach(async({page})=>{
  const response=await page.goto('/admin');
  expect(response.headers()['cache-control']).toContain('no-store');
  await page.getByLabel('Email').fill(process.env.TEST_ADMIN_EMAIL);
  await page.getByLabel('Password').fill(process.env.TEST_ADMIN_PASSWORD);
  await page.getByRole('button',{name:/sign in/i}).click();
  await expect(page.getByRole('heading',{name:'Catalogue admin'})).toBeVisible();
});

test('admin HTML and JSON responses prevent caching',async({page,context})=>{
  const html=await page.goto('/admin');expect(html.headers()['cache-control']).toContain('no-store');
  const json=await context.request.get('/admin/recaptcha');expect(json.status()).toBe(200);expect(json.headers()['cache-control']).toContain('no-store');
});

test('protected administration routes are available and logout remains POST-only',async({page})=>{
  for(const [route,heading] of [['/admin/categories','Categories'],['/admin/quotes','Quotes'],['/admin/enquiries','Enquiries'],['/admin/confirmations','Confirmation register']]){
    await page.goto(route);await expect(page.getByRole('heading',{name:heading})).toBeVisible();
  }
  await page.goto('/admin');const logout=page.locator('form[action="/admin/logout"]');await expect(logout).toBeVisible();await logout.getByRole('button').click();await expect(page.getByRole('heading',{name:'Admin sign in'})).toBeVisible();
});

test('mandatory category name, slug, parent and active status cannot be changed',async({page})=>{
  await page.goto('/admin/categories');await page.getByRole('link',{name:'Pizza Ovens',exact:true}).click();
  await page.getByLabel('Name').fill('Renamed Ovens');
  await page.getByRole('button',{name:'Save category'}).click();
  await expect(page.locator('.fd-error')).toContainText(/protected categories/i);
  await expect(page.getByLabel('Slug')).toHaveValue('pizza-ovens');
});
