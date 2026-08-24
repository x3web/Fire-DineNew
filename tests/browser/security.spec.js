const { test, expect } = require('@playwright/test');

test('CSRF and unsupported methods fail safely',async({request})=>{
  const quote=await request.post('/api/quotes',{data:{full_name:'Attack'}});expect(quote.status()).toBe(422);
  const enquiry=await request.post('/api/enquiries',{data:{first_name:'Attack'}});expect(enquiry.status()).toBe(422);
  expect((await request.put('/api/tracking-event',{data:{event_name:'test'}})).status()).toBe(405);
});

test('SQL probes are safely bounded',async({request})=>{
  const injection=await request.get('/api/products?q=%27%20OR%201%3D1--&per_page=2');expect(injection.status()).toBe(200);const payload=await injection.json();expect(payload.products.length).toBeLessThanOrEqual(2);
});

test('search escapes injected markup',async({page})=>{
  await page.goto('/shop?q=%3Cscript%3Ewindow.pwned%3D1%3C%2Fscript%3E');expect(await page.evaluate(()=>window.pwned)).toBeUndefined();expect(await page.locator('script').filter({hasText:'window.pwned'}).count()).toBe(0);
});

test('hidden and traversal targets are unavailable',async({request})=>{
  expect((await request.get('/product/flint-1')).status()).toBe(404);
  expect((await request.get('/category/accessories/domestic')).status()).toBe(404);
  expect((await request.get('/brochure/../../.env')).status()).toBeGreaterThanOrEqual(400);
  expect((await request.get('/database/install/Fire-And-Dine-Clean-Install.sql')).status()).toBeGreaterThanOrEqual(400);
});

test('CSP has no unsafe-inline and JSON-LD is valid',async({page})=>{
  const response=await page.goto('/product/counter-top-oven');const csp=await response.headerValue('content-security-policy');expect(csp).toBeTruthy();expect(csp).not.toContain("'unsafe-inline'");
  for(const script of await page.locator('script[type="application/ld+json"]').allTextContents())expect(()=>JSON.parse(script)).not.toThrow();
});
