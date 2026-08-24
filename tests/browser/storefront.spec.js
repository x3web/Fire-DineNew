const { test, expect } = require('@playwright/test');
const AxeBuilder = require('@axe-core/playwright').default;

const routes=['/','/about','/shop','/category','/category/pizza-ovens','/category/pizza-ovens/domestic','/category/pizza-ovens/mobile','/category/pizza-ovens/commercial','/category/accessories','/category/accessories/pizza-oven-utensils-accessories','/category/accessories/canvas-covers','/category/fireplace','/installation','/gallery','/contact','/faq','/cart','/checkout','/privacy-policy','/terms-of-service'];

for(const route of routes)test(`public route ${route}`,async({page})=>{
  const errors=[];page.on('console',message=>{if(message.type()==='error')errors.push(message.text());});page.on('pageerror',error=>errors.push(error.message));
  const response=await page.goto(route);expect(response.status(),route).toBeLessThan(400);await expect(page.locator('main h1').first()).toBeVisible();
  const accessibility=await new AxeBuilder({page}).withTags(['wcag2a','wcag2aa','wcag21aa']).analyze();expect(accessibility.violations).toEqual([]);expect(errors).toEqual([]);
});

test('all public pages, same-origin links and referenced assets resolve',async({page,request,baseURL})=>{
  const origin=new URL(baseURL).origin;
  const queue=routes.map(route=>new URL(route,baseURL).href);
  const visited=new Set();const links=new Set();const assets=new Set();const stylesheets=new Set();
  const sameOrigin=value=>{try{const url=new URL(value,baseURL);url.hash='';return url.origin===origin&&['http:','https:'].includes(url.protocol)?url.href:null;}catch{return null;}};
  const isPage=url=>{const parsed=new URL(url);return !parsed.pathname.startsWith('/admin')&&!parsed.pathname.startsWith('/api/')&&!parsed.pathname.startsWith('/brochure/')&&!/\.(?:avif|css|csv|eot|gif|ico|jpe?g|js|json|map|pdf|png|svg|txt|webm|webp|woff2?|xml|zip)$/i.test(parsed.pathname);};

  while(queue.length){
    const url=queue.shift();if(visited.has(url))continue;visited.add(url);expect(visited.size,'Public-page crawl exceeded its safety bound').toBeLessThanOrEqual(250);
    const response=await page.goto(url,{waitUntil:'domcontentloaded'});expect(response.status(),url).toBeLessThan(400);expect((await response.headerValue('content-type'))||'',url).toContain('text/html');
    const references=await page.evaluate(()=>{
      const links=[...document.querySelectorAll('a[href]')].map(node=>node.href);
      const assets=[];const stylesheets=[];
      for(const node of document.querySelectorAll('img[src],script[src],source[src],video[src],video[poster],audio[src],iframe[src],object[data],embed[src],link[href]')){
        const rel=(node.getAttribute('rel')||'').toLowerCase();const value=node.src||node.href||node.data||node.poster;
        if(!value)continue;if(node.tagName==='LINK'&&rel.includes('stylesheet'))stylesheets.push(value);
        if(node.tagName!=='LINK'||/(stylesheet|icon|preload|manifest)/.test(rel))assets.push(value);
      }
      for(const node of document.querySelectorAll('[srcset]'))for(const part of node.srcset.split(',')){const value=part.trim().split(/\s+/)[0];if(value)assets.push(new URL(value,document.baseURI).href);}
      return{links,assets,stylesheets};
    });
    for(const value of references.links){const normalized=sameOrigin(value);if(!normalized)continue;links.add(normalized);if(isPage(normalized)&&!visited.has(normalized)&&!queue.includes(normalized))queue.push(normalized);}
    for(const value of references.assets){const normalized=sameOrigin(value);if(normalized)assets.add(normalized);}
    for(const value of references.stylesheets){const normalized=sameOrigin(value);if(normalized)stylesheets.add(normalized);}
  }

  for(const url of links){const response=await request.get(url);expect(response.status(),url).toBeLessThan(400);}
  for(const url of assets){const response=await request.get(url);expect(response.status(),url).toBeLessThan(400);}
  for(const stylesheet of stylesheets){
    const response=await request.get(stylesheet);expect(response.status(),stylesheet).toBeLessThan(400);const css=await response.text();
    for(const match of css.matchAll(/url\(\s*(['"]?)(.*?)\1\s*\)/gi)){const value=match[2].trim();if(!value||value.startsWith('data:'))continue;const url=sameOrigin(new URL(value,stylesheet).href);if(!url)continue;const asset=await request.get(url);expect(asset.status(),`CSS reference ${url} from ${stylesheet}`).toBeLessThan(400);}
  }
  for(const route of ['/sitemap.xml','/robots.txt']){const response=await request.get(route);expect(response.status(),route).toBeLessThan(400);}
});

test('public API contract, filters and method handling',async({request})=>{
  expect((await request.get('/api/health')).status()).toBe(200);expect((await request.get('/api/categories')).status()).toBe(200);
  const response=await request.get('/api/products?category=pizza-ovens&subcategory=domestic&featured=0&q=oven&page=1&per_page=999');expect(response.status()).toBe(200);const data=await response.json();expect(data.pagination.per_page).toBeLessThanOrEqual(48);
  expect((await request.post('/api/products')).status()).toBe(405);expect((await request.get('/api/product?slug=does-not-exist')).status()).toBe(404);expect((await request.get('/api/products?category=accessories&subcategory=domestic')).status()).toBe(404);
  const legacy=await request.get('/api/brochure.php?id=5',{maxRedirects:0});expect(legacy.status()).toBe(301);expect(legacy.headers().location).toBe('/api/brochure?id=5');
});

test('basket caps merged quantities and can update and remove',async({page})=>{
  await page.goto('/product/counter-top-oven');const form=page.locator('[data-product-form]');await expect(form).toBeVisible();
  for(const group of await form.locator('[data-option-group]').all()){const required=await group.getAttribute('data-base-required');if(required==='true')await group.locator('input:not([disabled])').first().check();}
  await form.locator('input[name=quantity]').fill('60');await form.locator('button[type=submit]').click();await expect(form.locator('[role=status]')).toContainText(/added|quote/i);
  await form.locator('button[type=submit]').click();await page.goto('/cart');await expect(page.locator('input[type=number]').first()).toHaveValue('99');await page.locator('[data-remove]').first().click();await expect(page.locator('#quoteBasket')).toContainText(/empty/i);
});
