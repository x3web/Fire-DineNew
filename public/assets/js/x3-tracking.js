(() => {
  'use strict';
  const storage = { get(k){try{return localStorage.getItem(k)}catch{return null}}, set(k,v){try{localStorage.setItem(k,v)}catch{}} };
  const id = () => globalThis.crypto?.randomUUID?.() || `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;
  let visitorId = '';
  const params = new URLSearchParams(location.search);
  const attributionKeys = ['utm_source','utm_medium','utm_campaign','utm_content','utm_term','gclid','gbraid','wbraid','fbclid','ttclid','li_fat_id'];
  const currentAttribution = Object.fromEntries(attributionKeys.filter(k => params.has(k)).map(k => [k, params.get(k)]));
  const readJson = (key, fallback={}) => { try{return JSON.parse(storage.get(key)||'')||fallback}catch{return fallback} };
  let config = globalThis.X3_TRACKING_CONFIG || null;
  const consent = () => readJson('x3_consent', {necessary:true,analytics:false,advertising:false,personalisation:false});
  const persistVisitorAndAttribution = () => {
    const state = consent();
    if (config?.cookie_consent && !(state.analytics || state.advertising)) { visitorId = ''; return; }
    visitorId = storage.get('x3_visitor_id') || id();
    storage.set('x3_visitor_id', visitorId);
    if (Object.keys(currentAttribution).length) storage.set('x3_latest_attribution', JSON.stringify(currentAttribution));
    if (!storage.get('x3_first_attribution')) storage.set('x3_first_attribution', JSON.stringify(currentAttribution));
  };
  const permitted = eventName => {
    if (!config?.enabled) return false;
    if (!config.cookie_consent) return true;
    const state = consent();
    return ['purchase','refund','lead_generated','booking_completed'].includes(eventName) ? !!state.analytics : !!(state.analytics || state.advertising);
  };
  const sent = new Set();
  const normalizeData = data => ({...data, currency:data?.currency || config?.currency || 'ZAR'});
  async function track(eventName, eventData={}, options={}) {
    if (!permitted(eventName) && !options.necessary) return {skipped:'consent_or_disabled'};
    const eventId = options.event_id || eventData.event_id || id();
    if (sent.has(eventId)) return {event_id:eventId,duplicate:true}; sent.add(eventId);
    const data = normalizeData(eventData); const payload = {event_id:eventId,event_name:eventName,data,visitor_id:visitorId,url:location.href,referrer:document.referrer,consent:consent(),attribution:{first:readJson('x3_first_attribution'),latest:readJson('x3_latest_attribution')},test:!!config?.test_mode};
    if (config?.mode === 'gtm') { globalThis.dataLayer = globalThis.dataLayer || []; globalThis.dataLayer.push({event:eventName,event_id:eventId,...data}); }
    else dispatchDirect(eventName,eventId,data);
    try { const response=await fetch('/api/tracking-event',{method:'POST',headers:{'Content-Type':'application/json'},credentials:'same-origin',keepalive:true,body:JSON.stringify(payload)}); return response.ok?await response.json():{event_id:eventId,error:true}; }
    catch(error){ if(config?.debug) console.warn('X3Tracking delivery failed',error); return {event_id:eventId,error:true}; }
  }
  function dispatchDirect(eventName,eventId,data){
    const p=config?.platforms||{};
    if(p.google?.enabled&&typeof globalThis.gtag==='function') globalThis.gtag('event',eventName==='brochure_download'?'file_download':eventName,{...data,event_id:eventId});
    const metaMap={lead_generated:'Lead',add_to_cart:'AddToCart',begin_checkout:'InitiateCheckout',purchase:'Purchase',view_item:'ViewContent'};
    if(p.meta?.enabled&&typeof globalThis.fbq==='function') globalThis.fbq('track',metaMap[eventName]||'CustomEvent',{...data,event_name:eventName},{eventID:eventId});
    const ttMap={lead_generated:'SubmitForm',add_to_cart:'AddToCart',begin_checkout:'InitiateCheckout',purchase:'CompletePayment'};
    if(p.tiktok?.enabled&&globalThis.ttq?.track) globalThis.ttq.track(ttMap[eventName]||eventName,{...data,event_id:eventId});
  }
  function loadScript(src,id){if(id&&document.getElementById(id))return;const script=document.createElement('script');if(id)script.id=id;script.async=true;script.src=src;document.head.append(script);}
  function installPlatforms(){
    if(!config?.enabled||!permitted('page_view'))return;const p=config.platforms||{};
    if(config.mode==='gtm'&&/^GTM-[A-Z0-9]+$/.test(p.google?.gtm_id||'')){globalThis.dataLayer=globalThis.dataLayer||[];globalThis.dataLayer.push({'gtm.start':Date.now(),event:'gtm.js'});loadScript(`https://www.googletagmanager.com/gtm.js?id=${encodeURIComponent(p.google.gtm_id)}`,'x3-gtm');return;}
    if(p.google?.enabled&&/^G-[A-Z0-9]+$/.test(p.google.ga4_id||'')){globalThis.dataLayer=globalThis.dataLayer||[];globalThis.gtag=globalThis.gtag||function(){dataLayer.push(arguments)};gtag('js',new Date());gtag('config',p.google.ga4_id,{send_page_view:false});loadScript(`https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(p.google.ga4_id)}`,'x3-google');}
    if(p.meta?.enabled&&/^\d+$/.test(p.meta.pixel_id||'')){!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};n.queue=[];n.loaded=true;n.version='2.0';t=b.createElement(e);t.async=true;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');fbq('init',p.meta.pixel_id);}
    if(p.linkedin?.enabled&&/^\d+$/.test(p.linkedin.partner_id||'')){globalThis._linkedin_partner_id=p.linkedin.partner_id;globalThis._linkedin_data_partner_ids=globalThis._linkedin_data_partner_ids||[];globalThis._linkedin_data_partner_ids.push(p.linkedin.partner_id);loadScript('https://snap.licdn.com/li.lms-analytics/insight.min.js','x3-linkedin');}
  }
  globalThis.X3Tracking={track,getConsent:consent,visitorId:()=>visitorId,ready:null};
  globalThis.X3Tracking.ready=(async()=>{if(!config){try{config=await fetch('/api/tracking-config',{credentials:'same-origin'}).then(r=>r.json())}catch{config={enabled:false}}}return config})();
  globalThis.X3Tracking.ready.then(() => {
    persistVisitorAndAttribution();
    installPlatforms();
    track('page_view',{page_title:document.title,page_path:location.pathname});
    document.addEventListener('click', event => { const a=event.target.closest('a[href]'); if(!a)return; const href=a.href; if(a.matches('[data-x3-brochure-download]'))track('brochure_download',{file_type:'brochure',file_name:a.dataset.brochureName||'Fire & Dine Brochure',link_url:href});else if(href.startsWith('tel:'))track('phone_click',{link_url:href}); else if(href.startsWith('mailto:'))track('email_click',{link_url:href}); else if(/wa\.me|whatsapp/i.test(href))track('whatsapp_click',{link_url:href}); });
    document.addEventListener('focusin', event => { const form=event.target.closest('form'); if(form&&!form.dataset.x3Started){form.dataset.x3Started='1';track('form_start',{form_id:form.id||form.getAttribute('name')||'form'});} });
    document.addEventListener('x3:lead-success', event => track('lead_generated',event.detail||{}));
    document.addEventListener('x3:cart', event => track(event.detail?.action||'add_to_cart',event.detail||{}));
  });
if (!globalThis.__FD_CHANGE_FIXES_20260812__) {
  globalThis.__FD_CHANGE_FIXES_20260812__ = true;
  const fdPath = location.pathname.toLowerCase().replace(/\.(?:html|php)$/,'').replace(/\/$/,'') || '/';
  const normalise = value => String(value || '').trim().toLowerCase().replace(/&/g, 'and').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const safeImagePath = value => {
    if (!value) return '';
    try {
      const url = new URL(value, location.href);
      return url.origin === location.origin && (url.pathname.startsWith('/assets/images/') || url.pathname.startsWith('/uploads/products/')) ? `${url.pathname}${url.search}` : '';
    } catch (_) { return ''; }
  };
  const productData = card => {
    const image = card?.querySelector('img');
    return {
      name: card?.querySelector('h2,h3')?.textContent.trim() || 'Fire & Dine product',
      category: card?.querySelector('.eyebrow')?.textContent.trim() || '',
      image: safeImagePath(image?.getAttribute('src') || image?.currentSrc || '')
    };
  };
  const productUrl = data => {
    const url = new URL('/product', location.origin);
    if (data.name) url.searchParams.set('name', data.name);
    if (data.category) url.searchParams.set('category', data.category);
    if (data.image) url.searchParams.set('image', data.image);
    return `${url.pathname}${url.search}`;
  };

  document.querySelectorAll('.product').forEach(card => {
    const data = productData(card);
    card.querySelectorAll('a[href*="/product"]').forEach(link => { link.href = productUrl(data); });
  });

  if (fdPath === '/') {
    const categoryMap = new Map([
      ['pizza-ovens', 'pizza-ovens'],
      ['fireplaces', 'fireplaces'],
      ['accessories', 'accessories']
    ]);
    document.querySelectorAll('.category-section .card').forEach(card => {
      const category = categoryMap.get(normalise(card.querySelector('h2,h3')?.textContent));
      const link = card.querySelector('a[href]');
      if (category && link) link.href = `/shop?category=${encodeURIComponent(category)}`;
    });
  }

  const applyAfterPremium = () => {
    if (!document.getElementById('fd-change-fixes-style')) {
      const style = document.createElement('style');
      style.id = 'fd-change-fixes-style';
      style.textContent = `
        :root{
          --fd-eyebrow-font:'Inter',Arial,sans-serif;
          --fd-eyebrow-color:var(--gold,#fcbc4d);
          --fd-eyebrow-size:16px;
          --fd-eyebrow-weight:600;
          --fd-eyebrow-line-height:1.25;
          --fd-eyebrow-letter-spacing:.08em;
          --fd-eyebrow-transform:uppercase;
        }
        .eyebrow,.section-eyebrow,.hero-eyebrow,.page-eyebrow,.small-heading,.label-text,.quote-step-label,.service-kicker,.installation-kicker,.install-guidance-kicker,.stoneskin-panel-kicker,.cgs-kicker,.category-card__eyebrow,.kicker,.overline,.pre-title,.stand-guide-header>span{
          font-family:var(--fd-eyebrow-font)!important;
          font-weight:var(--fd-eyebrow-weight)!important;
          font-style:normal!important;
          font-size:var(--fd-eyebrow-size)!important;
          line-height:var(--fd-eyebrow-line-height)!important;
          letter-spacing:var(--fd-eyebrow-letter-spacing)!important;
          text-transform:var(--fd-eyebrow-transform)!important;
          display:inline-flex!important;
          align-items:center!important;
          justify-content:inherit!important;
          flex-wrap:nowrap!important;
          column-gap:8px!important;
          row-gap:.15em!important;
          width:fit-content!important;
          max-width:100%!important;
          margin:0 0 clamp(12px,1.2vw,18px)!important;
          color:var(--fd-eyebrow-color)!important;
          opacity:1!important;
          text-shadow:none!important;
        }
        .eyebrow i,.section-eyebrow i,.hero-eyebrow i,.page-eyebrow i,.service-kicker i,.installation-kicker i,.install-guidance-kicker i,.cgs-kicker i,.kicker i,.overline i,.pre-title i{display:inline-grid!important;place-items:center!important;flex:0 0 auto!important;color:inherit!important;font-size:14px!important;line-height:1!important}
        .fd-single-overlay{position:relative!important;isolation:isolate!important;background-blend-mode:normal!important}
        .fd-single-overlay::before{content:""!important;position:absolute!important;inset:0!important;display:block!important;background:rgba(0,0,0,.25)!important;opacity:1!important;z-index:0!important;pointer-events:none!important}
        .fd-single-overlay::after{display:none!important}
        .fd-single-overlay .hero-media::after,.fd-single-overlay .page-hero-media::after,.fd-single-overlay .image-cta-media::after{display:none!important}
        .fd-single-overlay>.shell,.fd-single-overlay>.image-cta-content{position:relative!important;z-index:1!important}
        .product-page-hero{min-height:clamp(300px,42vw,520px)!important;background-size:cover!important;background-position:center center!important;background-repeat:no-repeat!important}
        main>.hero,main>.page-hero,.product-page-hero,.image-page-hero,.legal-image-hero{text-align:center!important}
        main>.hero>.shell,main>.page-hero>.shell,.hero-slide>.shell,.product-page-hero>.shell,.image-page-hero>.shell,.legal-image-hero>.shell{
          width:100%!important;
          max-width:1120px!important;
          margin-inline:auto!important;
          display:flex!important;
          flex-direction:column!important;
          align-items:center!important;
          justify-content:center!important;
          text-align:center!important;
        }
        main>.hero .hero-copy,main>.hero .hero-content,main>.page-hero .hero-copy,main>.page-hero .hero-content,.hero-slide .hero-copy,.product-page-hero .hero-copy,.product-page-hero .hero-content,.image-page-hero .hero-copy,.image-page-hero .hero-content,.legal-image-hero .hero-copy,.legal-image-hero .hero-content{
          width:100%!important;
          max-width:1120px!important;
          margin-inline:auto!important;
          display:flex!important;
          flex-direction:column!important;
          align-items:center!important;
          justify-content:center!important;
          text-align:center!important;
        }
        main>.hero h1,main>.hero p,main>.page-hero h1,main>.page-hero p,.hero-slide h1,.hero-slide p,.product-page-hero h1,.product-page-hero p,.image-page-hero h1,.image-page-hero p,.legal-image-hero h1,.legal-image-hero p{
          text-align:center!important;
          margin-left:auto!important;
          margin-right:auto!important;
        }
        main>.hero .eyebrow,main>.page-hero .eyebrow,.hero-slide .eyebrow,.product-page-hero .eyebrow,.image-page-hero .eyebrow,.legal-image-hero .eyebrow{
          justify-content:center!important;
          text-align:center!important;
          margin-left:auto!important;
          margin-right:auto!important;
          margin-bottom:15px!important;
        }
        main>.hero .actions,main>.page-hero .actions,.hero-slide .actions,.product-page-hero .actions,.image-page-hero .actions,.legal-image-hero .actions{
          justify-content:center!important;
          margin-left:auto!important;
          margin-right:auto!important;
        }
        main>.hero .breadcrumbs,main>.page-hero .breadcrumbs,.product-page-hero .breadcrumbs,.image-page-hero .breadcrumbs,.legal-image-hero .breadcrumbs{
          justify-content:center!important;
          text-align:center!important;
          margin-inline:auto!important;
        }
        .toolbar.shop-filter-sticky{position:static!important;margin:0!important;padding:12px max(16px,calc((100vw - min(1500px,calc(100vw - 64px)))/2)) 14px!important;background:#fff!important;box-shadow:none!important}
        .toolbar.shop-filter-sticky .fd-clear-filters{margin-left:auto!important;white-space:nowrap}
        @media(max-width:1024px){
          main>.hero>.shell,main>.page-hero>.shell,.hero-slide>.shell,.product-page-hero>.shell,.image-page-hero>.shell,.legal-image-hero>.shell{max-width:min(1120px,calc(100% - 40px))!important}
        }
        @media(max-width:820px){.toolbar.shop-filter-sticky{top:82px!important;flex-wrap:wrap!important;padding-inline:16px!important}.toolbar.shop-filter-sticky>*{flex:1 1 180px!important}.toolbar.shop-filter-sticky .fd-clear-filters{flex:0 0 auto!important}}
        @media(max-width:600px){.toolbar.shop-filter-sticky{top:76px!important}}
        @media(max-width:600px){
          main>.hero>.shell,main>.page-hero>.shell,.hero-slide>.shell,.product-page-hero>.shell,.image-page-hero>.shell,.legal-image-hero>.shell{max-width:min(1120px,calc(100% - 32px))!important}
          main>.hero .actions,main>.page-hero .actions,.hero-slide .actions,.product-page-hero .actions,.image-page-hero .actions,.legal-image-hero .actions{width:min(100%,420px)!important}
        }
      `;
      document.head.append(style);
    }

    if (fdPath === '/product') {
      const params = new URLSearchParams(location.search);
      const detail = document.querySelector('.product-detail');
      const detailImage = detail?.querySelector('.shell > div:first-child > img, .two-col > div:first-child > img');
      const image = safeImagePath(params.get('image')) || safeImagePath(detailImage?.getAttribute('src') || detailImage?.currentSrc || '');
      const name = params.get('name') || detail?.querySelector('h1')?.textContent.trim() || 'Fire & Dine Product';
      const category = params.get('category');
      if (detailImage && image) {
        detailImage.src = image;
        detailImage.removeAttribute('srcset');
        detailImage.removeAttribute('sizes');
        detailImage.alt = name;
      }
      const detailHeading = detail?.querySelector('h1');
      if (detailHeading && name) detailHeading.textContent = name;
      const detailEyebrow = detail?.querySelector('.eyebrow span, .eyebrow');
      if (detailEyebrow && category) detailEyebrow.textContent = category;
      const hero = document.querySelector('.product-page-hero');
      if (hero) {
        const heading = hero.querySelector('h1');
        if (heading) heading.textContent = name;
        hero.style.setProperty('background-image', "url('/assets/images/hero-selected/shop-product-showcase-1920.webp')", 'important');
      }
      const support = document.querySelector('.product-support');
      const actions = detail?.querySelector('.actions');
      if (support && actions) {
        [...support.querySelectorAll('a.btn')].forEach(link => actions.append(link));
        support.remove();
      }
    }

    const ctaImageGroups = {
      consultation: ['/about','/about-us','/contact','/contact-us','/advice','/compare'],
      products: ['/shop','/product','/product-category','/category','/pizza-ovens','/diy-ovens','/residential-pizza-ovens','/mobile-compact-ovens','/outdoor-models'],
      showroom: ['/gallery','/showroom'],
      installation: ['/installation','/installations','/maintenance']
    };
    const ctaImageType = Object.entries(ctaImageGroups).find(([, paths]) => paths.includes(fdPath))?.[0] || 'quote';
    const ctaImageName = {
      consultation: '01-design-consultation',
      products: '02-shop-pizza-ovens',
      showroom: '03-visit-showroom',
      installation: '04-book-installation',
      quote: '05-request-quote'
    }[ctaImageType];
    const ctaFallbackImage = `/assets/images/fire-and-dine/cta/cta-${ctaImageName}-1916.webp`;
    document.querySelectorAll('.cta,.site-final-cta,.image-cta').forEach(section => {
      if (section.querySelector('.image-cta-media img')) return;
      const inlineBackground = section.style.backgroundImage || '';
      const computedBackground = getComputedStyle(section).backgroundImage || '';
      const existingBackground = /url\(/i.test(inlineBackground) ? inlineBackground : (/url\(/i.test(computedBackground) ? computedBackground : '');
      const backgroundImage = existingBackground || `linear-gradient(rgba(5,6,6,.78),rgba(5,6,6,.92)),url("${ctaFallbackImage}")`;
      section.style.setProperty('background-image', backgroundImage, 'important');
      section.style.setProperty('background-size', 'cover', 'important');
      section.style.setProperty('background-position', 'center', 'important');
      section.style.setProperty('background-repeat', 'no-repeat', 'important');
    });

    document.querySelectorAll('.hero,.page-hero,.cta,.site-final-cta,.image-cta').forEach(section => {
      const background = getComputedStyle(section).backgroundImage || '';
      const urls = background.match(/url\((?:"[^"]*"|'[^']*'|[^)]*)\)/g);
      if (urls?.length) section.style.setProperty('background-image', urls[urls.length - 1], 'important');
      section.classList.add('fd-single-overlay');
    });

    if (fdPath === '/shop') {
      const toolbar = document.querySelector('.toolbar');
      document.querySelectorAll('.shop-filter-sticky').forEach(element => element.classList.remove('shop-filter-sticky'));
      const params = new URLSearchParams(location.search);
      const search = toolbar?.querySelector('input[type="search"]');
      const category = toolbar?.querySelector('select');
      const sort = toolbar?.querySelectorAll('select')[1];
      if (sort && ![...sort.options].some(option => normalise(option.textContent).includes('featured'))) sort.insertAdjacentHTML('afterbegin', '<option value="featured">Featured</option>');
      const searchTerm = params.get('search') || '';
      const categorySlug = normalise(params.get('category'));
      const sortName = normalise(params.get('sort'));
      if (search && searchTerm) {
        search.value = searchTerm;
        search.dispatchEvent(new Event('input', { bubbles: true }));
      }
      if (category && categorySlug) {
        const aliases = { 'pizza-ovens':'pizza-ovens', 'pizza-oven':'pizza-ovens', fireplaces:'fireplaces', fireplace:'fireplaces', accessories:'accessories', accessory:'accessories' };
        const wanted = aliases[categorySlug] || categorySlug;
        const option = [...category.options].find(item => {
          const value = normalise(item.value || item.textContent);
          return value === wanted || value === wanted.replace(/s$/, '') || `${value}s` === wanted;
        });
        if (option) {
          category.value = option.value;
          category.dispatchEvent(new Event('change', { bubbles: true }));
        }
      }
      if (sort && sortName) {
        const option = [...sort.options].find(item => normalise(item.value || item.textContent) === sortName || normalise(item.textContent).includes(sortName.replace('price-', '')));
        if (option) { sort.value = option.value; sort.dispatchEvent(new Event('change', { bubbles: true })); }
      }
    }
  };
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', applyAfterPremium, { once: true });
  else queueMicrotask(applyAfterPremium);
}
})();
