document.addEventListener('DOMContentLoaded', () => {
  if (!document.querySelector('script[src$="x3-tracking.js"]')) {
    const trackingScript = document.createElement('script');
    trackingScript.src = '/assets/js/x3-tracking.js';
    trackingScript.defer = true;
    document.head.append(trackingScript);
  }
  const requestedFile = location.pathname.split('/').pop() || '';
  const cleanSlug = requestedFile.replace(/\.html$/i, '');
  const path = cleanSlug ? `/${cleanSlug}` : '/';
  const brochureUrl = document.documentElement.dataset.brochureUrl || '';
  const pageMain = document.querySelector('main');
  const applySectionRhythm = () => {
    if (!pageMain) return;
    pageMain.classList.add('site-main');
    [...pageMain.children].filter(element => element.tagName === 'SECTION').forEach((section, index) => {
      section.classList.remove('section-dark', 'section-light', 'section-dark-alt');
      const forcedDark = section.classList.contains('fd-force-dark');
      const forcedLight = section.classList.contains('fd-force-light');
      section.classList.add('page-section', forcedDark ? 'section-dark' : forcedLight ? 'section-light' : index % 2 === 0 ? 'section-dark' : 'section-light');
      if (index % 4 === 2) section.classList.add('section-dark-alt');
      section.dataset.sectionIndex = String(index + 1);
    });
  };
  applySectionRhythm();
  if (path === '/maintenance') location.replace('/installation#maintenance');
  if (path === '/installations') location.replace('/installation');
  if (path === '/terms') {
    document.title = 'Terms of Service | Fire & Dine';
    const legalHeading = document.querySelector('.page-hero h1');
    if (legalHeading) legalHeading.textContent = 'Terms of Service';
  }

  const pageMeta = {
    '/': ['Fire & Dine | Pizza Ovens, Fireplaces & Accessories', 'Explore Fire & Dine pizza ovens, fireplaces and accessories for residential and commercial spaces.', 'https://fireanddine.co.za/'],
    '/about': ['About Fire & Dine | Wood-Fired Living', 'Learn about Fire & Dine and our range of pizza ovens, fireplaces and accessories for homes and commercial customers.', 'https://fireanddine.co.za/about'],
    '/shop': ['Shop Pizza Ovens, Fireplaces & Accessories | Fire & Dine', 'Shop the existing Fire & Dine range of pizza ovens, fireplaces and accessories.', 'https://fireanddine.co.za/shop'],
    '/installation': ['Pizza Oven Installation & Maintenance | Fire & Dine', 'Installation, curing, safe use and ongoing maintenance guidance for Fire & Dine products.', 'https://fireanddine.co.za/installation'],
    '/contact': ['Contact Fire & Dine | Product Advice & Quotes', 'Contact Fire & Dine for product guidance, installation support and quotation enquiries.', 'https://fireanddine.co.za/contact']
    ,'/showroom': ['Fire & Dine Show Room | Visit Us in Vanderbijlpark', 'Visit the Fire & Dine show room in Vanderbijlpark to explore selected pizza ovens, fireplaces and accessories.', 'https://fireanddine.co.za/showroom']
    ,'/gallery': ['Fire & Dine Gallery | Pizza Ovens, Fireplaces & Commercial Spaces', 'Explore Fire & Dine residential, commercial and lifestyle inspiration.', 'https://fireanddine.co.za/gallery']
    ,'/pizza-ovens': ['Pizza Ovens | Residential, DIY, Mobile & Commercial | Fire & Dine', 'Explore Fire & Dine residential, DIY, mobile, compact and commercial pizza ovens.', 'https://fireanddine.co.za/pizza-ovens']
    ,'/commercial-ovens': ['Commercial Pizza Ovens | Fire & Dine', 'Discuss commercial pizza oven capacity, output, space and delivery requirements.', 'https://fireanddine.co.za/commercial-ovens']
    ,'/fireplaces': ['Fireplaces | Built-In & Freestanding | Fire & Dine', 'Explore built-in and freestanding fireplaces by room size and installation need.', 'https://fireanddine.co.za/fireplaces']
    ,'/accessories': ['Pizza Oven & Fireplace Accessories | Fire & Dine', 'Shop cooking, fire-management, cleaning and storage accessories.', 'https://fireanddine.co.za/accessories']
    ,'/residential-pizza-ovens': ['Residential Pizza Ovens | Fire & Dine', 'Explore residential pizza ovens for patios and home entertainment spaces.', 'https://fireanddine.co.za/residential-pizza-ovens']
    ,'/outdoor-models': ['Outdoor Models | Fire & Dine', 'Explore Fire & Dine outdoor pizza ovens, fireplaces and finishes for patios and entertainment spaces.', 'https://fireanddine.co.za/outdoor-models']
    ,'/mobile-compact-ovens': ['Mobile & Compact Pizza Ovens | Fire & Dine', 'Explore smaller-footprint and movable pizza oven configurations.', 'https://fireanddine.co.za/mobile-compact-ovens']
    ,'/diy-ovens': ['DIY Pizza Ovens | Fire & Dine', 'Plan a DIY pizza oven around preparation, finishing and curing.', 'https://fireanddine.co.za/diy-ovens']
    ,'/compare': ['Compare Fire & Dine Products | Pizza Ovens & Fireplaces', 'Compare the currently listed Fire & Dine products and request guidance for your home or commercial space.', 'https://fireanddine.co.za/compare']
    ,'/advice': ['Fire & Dine Advice Centre | Installation, Care & Product Guidance', 'Find Fire & Dine installation, curing, flue and StoneSkin application guidance.', 'https://fireanddine.co.za/advice']
    ,'/stoneskin': ['StoneSkin Decorative Stone Coating | Fire & Dine', 'Explore StoneSkin decorative stone coating for patios, pool surrounds, entertainment spaces, braai and boma walls and feature walls.', 'https://fireanddine.co.za/stoneskin']
  };

  /* Existing Outdoor Models cards now resolve to the dedicated range page. */
  document.querySelectorAll('h2, h3').forEach(heading => {
    if (heading.textContent.trim().toLowerCase() !== 'outdoor models') return;
    const card = heading.closest('article, .card, .content-box');
    const link = card?.querySelector('a[href]');
    if (link) link.href = '/outdoor-models';
  });
  if (pageMeta[path]) {
    const [title, description, canonical] = pageMeta[path];
    document.title = title;
    document.querySelector('meta[name="description"]')?.setAttribute('content', description);
    const upsert = (selector, attributes) => { let element = document.head.querySelector(selector); if (!element) { element = document.createElement(attributes.property ? 'meta' : 'link'); document.head.append(element); } Object.entries(attributes).forEach(([key, value]) => element.setAttribute(key, value)); };
    upsert('link[rel="canonical"]', { rel: 'canonical', href: canonical });
    upsert('meta[property="og:title"]', { property: 'og:title', content: title });
    upsert('meta[property="og:description"]', { property: 'og:description', content: description });
    upsert('meta[property="og:url"]', { property: 'og:url', content: canonical });
    upsert('meta[property="og:type"]', { property: 'og:type', content: 'website' });
  }
  const responsivePicture = (base, alt, width = 1672, height = 941, eager = false, className = '') => `<picture class="${className}"><source type="image/avif" srcset="${base}-640.avif 640w, ${base}-960.avif 960w, ${base}-1440.avif 1440w, ${base}-${width}.avif ${width}w" sizes="100vw"><source type="image/webp" srcset="${base}-640.webp 640w, ${base}-960.webp 960w, ${base}-1440.webp 1440w, ${base}-${width}.webp ${width}w" sizes="100vw"><img src="${base}.png" width="${width}" height="${height}" alt="${alt}" loading="${eager ? 'eager' : 'lazy'}" decoding="async"${eager ? ' fetchpriority="high"' : ''}></picture>`;

  const pageHero = document.querySelector('.hero, .page-hero');
  const setHero = (label, heading, copy) => {
    if (!pageHero) return;
    const eyebrow = pageHero.querySelector('.eyebrow');
    const title = pageHero.querySelector('h1');
    let paragraph = pageHero.querySelector('p');
    if (!paragraph && title) { paragraph = document.createElement('p'); title.after(paragraph); }
    if (eyebrow) eyebrow.textContent = label;
    if (title) title.textContent = heading;
    if (paragraph) paragraph.textContent = copy;
  };
  if (path === '/') setHero('Premium Fireplaces • Pizza Ovens • Outdoor Living', 'Crafted for Warmth, Fire & Unforgettable Gatherings', 'Premium fireplaces, handcrafted pizza ovens and outdoor living solutions built for warmth, style and unforgettable moments.');
  if (path === '/about') setHero('Since 2013', 'Bringing People Together Through Fire, Flavour and Warmth', 'Fire & Dine supplies premium pizza ovens, fireplaces and accessories designed to enhance the way people cook, entertain and enjoy their spaces.');
  if (path === '/shop') setHero('Explore our collection', 'Shop Pizza Ovens, Fireplaces and Accessories', 'Explore premium fire products for home entertainment, everyday cooking, professional kitchens and comfortable living spaces.');
  if (path === '/installation') setHero('Installation and ongoing care', 'Installation', 'This page covers installation preparation, curing, safe operation and ongoing maintenance. Always follow the instructions supplied with your specific product.');
  if (path === '/installation') document.body.classList.add('fd-installation-page');
  if (path === '/contact') document.body.classList.add('fd-contact-page');
  if (path === '/contact') setHero('Contact Fire & Dine', 'Let’s Find the Right Fire & Dine Product for You', 'Whether you are selecting a residential pizza oven, planning a commercial kitchen, comparing fireplaces or discussing a custom finish, our team is ready to assist.');
  if (path === '/contact') {
    const hero=document.querySelector('.page-hero');
    const pathways=document.createElement('section'); pathways.className='section enquiry-pathways'; pathways.innerHTML='<div class="shell"><div class="section-head"><span class="eyebrow">Choose your enquiry</span><h2>Reach the Right Conversation Faster</h2><p>Select the subject that best matches the assistance you need.</p></div><div class="cards journey-grid"><article class="content-box"><h2>Product Sales</h2><p>Residential pizza ovens, fireplaces and accessories.</p><a class="text-link" href="#contact-form">Product enquiry →</a></article><article class="content-box"><h2>Commercial</h2><p>Capacity, output, installation space and commercial delivery.</p><a class="text-link" href="/commercial-ovens#commercial-form">Commercial consultation →</a></article><article class="content-box"><h2>Installation Support</h2><p>Preparation, curing, maintenance or technical questions.</p><a class="text-link" href="#contact-form">Technical enquiry →</a></article><article class="content-box"><h2>Orders &amp; Trade</h2><p>Existing orders, dealer enquiries and trade conversations.</p><a class="text-link" href="#contact-form">Order or trade enquiry →</a></article></div></div>'; hero?.after(pathways);
    const productSelect=document.querySelector('#contact-form [name="product"]'); if(productSelect){productSelect.insertAdjacentHTML('beforeend','<option>Existing order</option><option>Dealer or trade enquiry</option>');}
    const contactNote=document.querySelector('.contact-details .form-note'); contactNote?.insertAdjacentHTML('afterend','<p class="form-note"><strong>Visits and appointments:</strong> Contact the team before travelling to confirm availability and arrange assistance.</p>');
  }
  if (false && path === '/') {
    const hero = document.querySelector('.hero');
    if (hero) {
      const heroPreload=document.createElement('link');heroPreload.rel='preload';heroPreload.as='image';heroPreload.href='assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-1440.avif';heroPreload.type='image/avif';heroPreload.setAttribute('imagesrcset','assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-640.avif 640w, assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-960.avif 960w, assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-1440.avif 1440w, assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-1916.avif 1916w');heroPreload.setAttribute('imagesizes','100vw');document.head.append(heroPreload);
      const slides = [
        ['hero-05-mountain-terrace','Premium Fireplaces • Pizza Ovens • Outdoor Living','Crafted for Warmth, Fire & Unforgettable Gatherings','Premium fireplaces, handcrafted pizza ovens and outdoor living solutions built for warmth, style and memorable moments.','Shop the Collection','/shop','Request a Quote','/contact','center center'],
        ['hero-01-social-dining','Live-fire entertaining','Bring People Together Around the Fire','Create an unforgettable entertaining space with premium pizza ovens and fireplaces.','Explore Pizza Ovens','/shop#pizza-ovens','Book a Consultation','/contact','center center'],
        ['hero-02-craftsmanship','Craftsmanship','Crafted with Purpose. Built to Last.','Discover fire products created with careful workmanship and premium materials.','Our Story','/about','View the Collection','/shop','left center'],
        ['hero-04-product-showcase','Pizza Ovens • Fireplaces • Accessories','Premium Fire Products for Exceptional Spaces','Explore pizza ovens, fireplaces and outdoor-living products designed for performance and style.','Shop Products','/shop','Speak to an Expert','/contact','right center'],
        ['hero-03-city-view-terrace','Outdoor living','Transform Your Outdoor Living Space','Bring warmth, atmosphere and live-fire cooking into your home.','View Installations','/installation','Request a Quote','/contact','center center'],
        ['hero-06-evening-gathering','Warmth • Food • Connection','Made for Evenings Worth Remembering','Create a warm and welcoming setting for family, friends and exceptional food.','Explore the Range','/shop','Visit Our Show Room','/showroom','center center']
      ];
      const firstSources = name => `<source type="image/avif" srcset="assets/images/fire-and-dine/heroes/${name}-640.avif 640w, assets/images/fire-and-dine/heroes/${name}-960.avif 960w, assets/images/fire-and-dine/heroes/${name}-1440.avif 1440w, assets/images/fire-and-dine/heroes/${name}-1916.avif 1916w" sizes="100vw"><source type="image/webp" srcset="assets/images/fire-and-dine/heroes/${name}-640.webp 640w, assets/images/fire-and-dine/heroes/${name}-960.webp 960w, assets/images/fire-and-dine/heroes/${name}-1440.webp 1440w, assets/images/fire-and-dine/heroes/${name}-1916.webp 1916w" sizes="100vw"><img src="assets/images/fire-and-dine/heroes/${name}.png" width="1916" height="821" alt="" loading="eager" decoding="async" fetchpriority="high">`;
      const lazySources = name => `<source type="image/avif" data-srcset="assets/images/fire-and-dine/heroes/${name}-640.avif 640w, assets/images/fire-and-dine/heroes/${name}-960.avif 960w, assets/images/fire-and-dine/heroes/${name}-1440.avif 1440w, assets/images/fire-and-dine/heroes/${name}-1916.avif 1916w" sizes="100vw"><source type="image/webp" data-srcset="assets/images/fire-and-dine/heroes/${name}-640.webp 640w, assets/images/fire-and-dine/heroes/${name}-960.webp 960w, assets/images/fire-and-dine/heroes/${name}-1440.webp 1440w, assets/images/fire-and-dine/heroes/${name}-1916.webp 1916w" sizes="100vw"><img data-src="assets/images/fire-and-dine/heroes/${name}.png" width="1916" height="821" alt="" loading="lazy" decoding="async">`;
      hero.classList.add('home-hero'); hero.setAttribute('aria-roledescription','carousel'); hero.setAttribute('aria-label','Fire & Dine highlights');
      hero.innerHTML = `<div class="hero-slides">${slides.map((slide,index)=>`<article class="hero-slide${index===0?' active':''}" data-position="${slide[8]}" aria-hidden="${index!==0}"><picture class="hero-media">${index===0?firstSources(slide[0]):lazySources(slide[0])}</picture><div class="shell"><div class="hero-copy"><span class="eyebrow">${slide[1]}</span><h1>${slide[2]}</h1><p>${slide[3]}</p><div class="actions"><a class="btn btn-gold" href="${slide[5]}">${slide[4]}</a><a class="btn btn-outline" href="${slide[7]}">${slide[6]}</a></div></div></div></article>`).join('')}</div><div class="hero-controls shell"><button class="hero-arrow hero-prev" type="button" aria-label="Previous hero slide">‹</button><div class="hero-dots">${slides.map((_,i)=>`<button type="button" aria-label="Show slide ${i+1}" aria-current="${i===0}"></button>`).join('')}</div><button class="hero-arrow hero-next" type="button" aria-label="Next hero slide">›</button></div>`;
      const slideElements=[...hero.querySelectorAll('.hero-slide')], dots=[...hero.querySelectorAll('.hero-dots button')]; let active=0, timer;
      const loadSlide = element => { element.querySelectorAll('[data-srcset]').forEach(source=>{source.srcset=source.dataset.srcset;source.removeAttribute('data-srcset')}); element.querySelectorAll('[data-src]').forEach(image=>{image.src=image.dataset.src;image.removeAttribute('data-src')}); };
      const showSlide = next => { active=(next+slideElements.length)%slideElements.length; slideElements.forEach((slide,i)=>{const selected=i===active;slide.classList.toggle('active',selected);slide.setAttribute('aria-hidden',String(!selected));if(selected)loadSlide(slide)});dots.forEach((dot,i)=>dot.setAttribute('aria-current',String(i===active))); };
      hero.querySelector('.hero-prev').addEventListener('click',()=>showSlide(active-1)); hero.querySelector('.hero-next').addEventListener('click',()=>showSlide(active+1)); dots.forEach((dot,i)=>dot.addEventListener('click',()=>showSlide(i))); hero.addEventListener('keydown',event=>{if(event.key==='ArrowLeft')showSlide(active-1);if(event.key==='ArrowRight')showSlide(active+1)});
      const reduced=matchMedia('(prefers-reduced-motion: reduce)'); const start=()=>{if(!reduced.matches&&!document.hidden)timer=setInterval(()=>showSlide(active+1),7000)}; const stop=()=>clearInterval(timer); hero.addEventListener('mouseenter',stop);hero.addEventListener('mouseleave',start);document.addEventListener('visibilitychange',()=>document.hidden?stop():(stop(),start()));start();
      stop();
      hero.classList.add('home-hero-static');
      hero.removeAttribute('aria-roledescription');
      hero.setAttribute('aria-label','Fire & Dine introduction');
      hero.innerHTML = `<article class="hero-slide active" data-position="center center"><picture class="hero-media">${firstSources('hero-05-mountain-terrace')}</picture><div class="shell"><div class="hero-copy"><span class="eyebrow">Premium Fireplaces &bull; Pizza Ovens &bull; Outdoor Living</span><h1>Crafted for Warmth,<br><span>Fire &amp; Unforgettable Gatherings</span></h1><p>Premium fireplaces, handcrafted pizza ovens and outdoor living solutions built for warmth, style and memorable moments.</p><div class="actions"><a class="btn btn-gold" href="/shop">Shop Our Range</a><a class="btn btn-outline" href="/contact">Request a Quote</a></div></div></div></article>`;
    }
    const categorySection=document.querySelector('.cream');
    if(categorySection){
      const categoryPicture=(name,alt,position='center center')=>`<div class="category-card__media"><picture><source type="image/avif" srcset="assets/images/fire-and-dine/categories/${name}-640.avif 640w, assets/images/fire-and-dine/categories/${name}-960.avif 960w, assets/images/fire-and-dine/categories/${name}-1440.avif 1440w, assets/images/fire-and-dine/categories/${name}-1672.avif 1672w" sizes="(min-width:1000px) 33vw, (min-width:650px) 50vw, 100vw"><source type="image/webp" srcset="assets/images/fire-and-dine/categories/${name}-640.webp 640w, assets/images/fire-and-dine/categories/${name}-960.webp 960w, assets/images/fire-and-dine/categories/${name}-1440.webp 1440w, assets/images/fire-and-dine/categories/${name}-1672.webp 1672w" sizes="(min-width:1000px) 33vw, (min-width:650px) 50vw, 100vw"><img src="assets/images/fire-and-dine/categories/${name}.png" width="1672" height="941" alt="${alt}" loading="lazy" decoding="async" style="object-position:${position}"></picture></div>`;
      categorySection.setAttribute('aria-labelledby','shop-categories-title');
      categorySection.innerHTML=`<div class="shell"><header class="section-head"><span class="eyebrow">Explore the Range</span><h2 id="shop-categories-title">Designed Around Fire, Food and Living</h2><p>Explore pizza ovens, fireplaces and accessories for cooking, warmth and entertaining.</p></header><div class="category-grid"><a class="category-card" href="/shop#pizza-ovens">${categoryPicture('fire-and-dine-pizza-ovens-category','Premium Fire & Dine wood-fired pizza oven in an outdoor entertainment area')}<div class="category-card__content"><span class="category-card__eyebrow">Live-fire cooking</span><h3>Pizza Ovens</h3><p>Discover wood-fired pizza ovens designed for unforgettable meals, entertaining and commercial requirements.</p><span class="category-card__cta">View Pizza Ovens <b aria-hidden="true">→</b></span></div></a><a class="category-card" href="/shop#fireplaces">${categoryPicture('fire-and-dine-fireplaces-category','Modern Fire & Dine fireplace in a warm luxury living room')}<div class="category-card__content"><span class="category-card__eyebrow">Warmth and atmosphere</span><h3>Fireplaces</h3><p>Explore fireplace solutions created to bring warmth, atmosphere and refined style into your home.</p><span class="category-card__cta">View Fireplaces <b aria-hidden="true">→</b></span></div></a><a class="category-card" href="/shop#accessories">${categoryPicture('fire-and-dine-accessories-category','Premium pizza oven tools and accessories beside a glowing wood-fired oven','right center')}<div class="category-card__content"><span class="category-card__eyebrow">Complete the experience</span><h3>Accessories</h3><p>Complete your fire-cooking experience with tools, pizza peels, gloves and essential oven accessories.</p><span class="category-card__cta">View Accessories <b aria-hidden="true">→</b></span></div></a></div></div>`;
    }
    const homeTitle = pageHero?.querySelector('h1');
    if (homeTitle) homeTitle.innerHTML = 'Crafted for Warmth,<br><span>Fire &amp; Unforgettable Gatherings</span>';
    const heroButtons = pageHero?.querySelectorAll('.actions a');
    if (heroButtons?.[0]) { heroButtons[0].href = '/shop'; heroButtons[0].textContent = 'Shop Our Range'; }
    if (heroButtons?.[1]) { heroButtons[1].href = '/contact'; heroButtons[1].innerHTML = 'Request a Quote'; }
    document.querySelectorAll('a[href="/installations"], a[href="/maintenance"]').forEach(link => { link.href = '/installation'; if (link.closest('.split')) link.textContent = 'View Installation Information'; });
    document.querySelectorAll('.card').forEach(card => { const link = card.querySelector('a.text-link'); const heading = card.querySelector('h3')?.textContent.toLowerCase(); if (!link) return; if (heading?.includes('pizza')) link.href = '/shop#pizza-ovens'; if (heading?.includes('fireplace')) link.href = '/shop#fireplaces'; if (heading?.includes('accessories')) link.href = '/shop#accessories'; });
    const stories = [...document.querySelectorAll('.section')].find(section => section.querySelector('.quote-grid'));
    if (stories) stories.innerHTML = '<div class="shell"><div class="section-head"><span class="eyebrow">Find the right product</span><h2>Choose Around Your Space and Use</h2><p>Start with the most relevant product family, then compare published products or speak to the team.</p></div><div class="cards journey-grid"><article class="content-box"><h2>Residential Pizza Ovens</h2><p>For patios, outdoor kitchens and home entertainment areas.</p><a class="text-link" href="/residential-pizza-ovens">Explore Residential Ovens →</a></article><article class="content-box"><h2>Commercial Ovens</h2><p>For restaurants, hospitality, caterers and serious service requirements.</p><a class="text-link" href="/commercial-ovens">Discuss a Commercial Oven →</a></article><article class="content-box"><h2>Mobile &amp; Compact</h2><p>Smaller-footprint and movable configurations for flexible cooking spaces.</p><a class="text-link" href="/mobile-compact-ovens">Explore Compact Ovens →</a></article><article class="content-box"><h2>Fireplaces</h2><p>Built-in and freestanding warmth organised around room and installation needs.</p><a class="text-link" href="/fireplaces">Explore Fireplaces →</a></article></div></div>';
    stories?.classList.add('home-audiences');
  }
  if (false && path === '/about') {
    const openingImage = document.querySelector('main .two-col > div:first-child');
    if (openingImage) { openingImage.closest('.two-col')?.classList.add('about-story-grid'); openingImage.innerHTML = responsivePicture('assets/images/fire-and-dine/about/about-us-workshop','Fire & Dine craftsman working in a workshop with premium pizza ovens and fireplaces'); }
    const consultation = document.createElement('section'); consultation.className='split'; consultation.innerHTML=`<div class="split-media">${responsivePicture('assets/images/fire-and-dine/about/about-us-consultation','Fire & Dine product consultation beside a glowing pizza oven and fireplace',1672,941,false)}</div><div class="split-copy"><span class="eyebrow">Personal guidance</span><h2>Choose with Confidence</h2><p>Discuss your available space, intended use and product requirements with the Fire & Dine team.</p><a class="btn btn-outline" href="/gallery">View the Gallery</a></div>`; document.querySelector('main')?.append(consultation);
    const pillars=document.querySelector('main .cards'); if(pillars){pillars.classList.add('journey-grid');pillars.innerHTML='<article class="content-box"><h2>Product Range</h2><p>Residential and commercial pizza ovens, fireplaces and practical accessories for different spaces and uses.</p></article><article class="content-box"><h2>Craftsmanship</h2><p>Explore product, finish and material details through the published range and Gallery imagery.</p></article><article class="content-box"><h2>Customer Support</h2><p>Get help with product selection, delivery preparation, installation information, curing and ongoing care.</p></article><article class="content-box"><h2>Customisation</h2><p>Ask which finish, thermometer, mosaic or coastal options apply to the product you are considering.</p></article>';}
  }
  const imageHeroMap = {
    '/about':['assets/images/fire-and-dine/heroes/hero-01-social-dining','Guests gathering around a Fire & Dine pizza oven'],
    '/shop':['assets/images/fire-and-dine/heroes/hero-04-product-showcase','Premium Fire & Dine pizza oven product showcase'],
    // The installation page uses the exact background supplied in the change brief
    // via its --hero-* custom properties. Do not cover it with a second hero image.
    '/privacy-policy':['assets/images/fire-and-dine/legal/privacy-policy','Secure document and lock representing the Fire & Dine privacy policy'],
    '/terms':['assets/images/fire-and-dine/legal/terms-of-service','Service agreement document in a warm Fire & Dine setting']
  };
  if (imageHeroMap[path]) { const hero=document.querySelector('.page-hero'); if(hero){const wideHero=path==='/about'||path==='/shop';hero.classList.add('image-page-hero'); if(path==='/privacy-policy'||path==='/terms')hero.classList.add('legal-image-hero'); hero.insertAdjacentHTML('afterbegin',responsivePicture(imageHeroMap[path][0],imageHeroMap[path][1],wideHero?1916:1672,wideHero?821:941,true,'page-hero-media'));} }

  const editorial = {
    '/': [
      ['Made for Flavour, Warmth and Connection', 'The best spaces are the ones people naturally gather around. Fire & Dine supplies premium fire products designed to transform the way you cook, entertain and enjoy your surroundings.'],
      ['Turn Everyday Meals Into Memorable Occasions', 'Choose from compact, mobile, DIY and permanent residential ovens designed for different spaces, cooking requirements and budgets.'],
      ['Wood-Fired Performance for Professional Kitchens', 'Our commercial ovens offer generous cooking capacity, reliable heat retention and dependable performance for restaurants, caterers and hospitality venues.'],
      ['Designed to Complement Your Space', 'Selected ovens can be personalised with smooth or textured finishes, brick-face details, mosaic designs, built-in thermometers, coastal upgrades, mobile stands, side tables and gas conversion.'],
      ['Experience Fire & Dine in Person', 'Visit our showroom at Vanderbijlpark, Gauteng, 1911 to explore selected products and discuss your project.']
    ],
    '/about': [
      ['Built Around the Experience of Fire', 'Some of life’s most memorable moments happen around food, warmth and good company. Fire & Dine was created around the belief that the right fire product can transform an ordinary space into somewhere people naturally want to gather.'],
      ['Solutions for Homes and Businesses', 'Our collection includes residential and commercial pizza ovens, freestanding and built-in fireplaces, and practical accessories for homeowners, restaurants, caterers and professional kitchens.'],
      ['Guidance From Selection to Ongoing Care', 'Our team assists with product selection, oven sizing, customisation, delivery arrangements, installation preparation, curing, maintenance and fireplace selection.'],
      ['A Personalised and Practical Buying Experience', 'Choose from multiple product configurations and selected custom finishes, supported by clear recommendations, delivery coordination, a physical showroom and direct product support.']
    ],
    '/shop': [
      ['Find the Right Product for Your Space', 'Our collection includes residential and commercial pizza ovens, fireplaces and purpose-built accessories in a variety of sizes, configurations and selected finishes.'],
      ['Authentic Wood-Fired Cooking Starts Here', 'Explore DIY, residential, mobile, countertop, steel, compact and commercial pizza ovens with selected thermometers, coastal upgrades and custom finishes.'],
      ['Warmth With Lasting Visual Impact', 'Explore freestanding and built-in fireplaces for different living areas, room sizes and heating requirements.'],
      ['Delivery Coordinated According to Your Location', 'Delivery costs and arrangements depend on the selected product, destination, shipping route, product weight, unloading requirements and installation access.']
    ],
    '/installation': [
      ['Prepare Carefully Before Your Oven Arrives', 'Confirm the oven dimensions, base dimensions, product weight, access, lifting assistance, installation materials, ventilation requirements, weather exposure and surrounding combustible materials.'],
      ['Build a Stable and Level Supporting Structure', 'Install the oven on a strong permanent base that can safely support its weight. The supporting structure must be correctly sized, level and fully cured before positioning.'],
      ['Lift and Position the Oven Safely', 'Use adequate assistance and ensure the oven is centred, fully supported, stable, aligned, positioned at the required gradient and clear of unsafe surrounding materials.'],
      ['Complete and Seal the Installation', 'Use suitable heat-resistant materials around joints and finishes. Allow mortar, adhesives and building finishes to dry fully before curing the oven.'],
      ['Five-Day Curing Process', 'Heat gradually for two to three hours per day: approximately 60°C on day one, 100°C on day two, 150°C on day three, 200°C on day four and 250°C on day five.'],
      ['Use Recommended Temperatures', 'For normal use, keep the oven below approximately 350°C unless your product instructions state otherwise. Never use water to cool a hot oven.'],
      ['Use Dry, Properly Seasoned Wood', 'Burn only clean cooking wood. Never burn treated timber, painted wood, laminated boards, chipboard, plastic, household waste or contaminated material.'],
      ['Routine Cleaning and Ash Removal', 'Let the oven cool completely, remove loose ash and debris with suitable tools, and store ash in a metal container until no heat or embers remain.'],
      ['Protect the Oven From Moisture', 'Keep the door closed during wet weather, maintain the exterior finish and use suitable overhead protection where possible. Never cover a warm oven with a non-breathable cover.'],
      ['Monitor Cracks and Exterior Finishes', 'Fine hairline cracks are common in refractory materials. Larger or widening cracks should be assessed and repaired with suitable heat-resistant mortar.'],
      ['Keep the Chimney and Flue Clear', 'Inspect periodically for soot, grease, ash and obstructions. Arrange professional cleaning where deposits are heavy or access is unsafe.'],
      ['Coastal Installations', 'Salt air increases corrosion. Ask about coastal-grade upgrades and regularly clean exposed metal, inspect for corrosion and maintain protective coatings.']
    ],
    '/contact': [
      ['Tell Us About Your Project', 'Share your product interest, available space, delivery location, preferred size, customisation requirements and installation needs so we can provide relevant advice.'],
      ['Planning a Commercial Installation?', 'Include your business type, expected cooking volume, available installation space, oven capacity, delivery location and expected project timeline.'],
      ['Need Installation or Maintenance Advice?', 'Send the product name, photographs of the product and installation area, a description of the issue, installation date and maintenance already completed.']
    ]
  };
  const aboutAccordion = [
    ['Built Around the Experience of Fire', 'Fire & Dine helps customers create welcoming spaces centred on live-fire cooking, warmth and time spent together.'],
    ['Solutions for Homes and Businesses', 'The range includes residential and commercial pizza ovens, fireplaces and practical accessories for different spaces and uses.'],
    ['Guidance From Selection to Ongoing Care', 'The team can assist with product selection, delivery preparation, installation information, curing and ongoing maintenance guidance.'],
    ['A Personal and Practical Buying Experience', 'Customers can discuss their available space, intended use, preferred configuration and delivery requirements directly with the team.'],
    ['Compare Products With Confidence', 'Use the published product information and comparison tools, then contact Fire & Dine when a project needs individual guidance.'],
    ['Residential Fire Products', 'Explore pizza ovens, fireplaces and accessories suited to homes, patios and outdoor entertainment areas.'],
    ['Commercial Requirements', 'Restaurants, caterers and hospitality venues can discuss cooking volume, capacity, placement and access requirements.'],
    ['Installation Preparation', 'Review the general installation information and always follow the instructions supplied with the selected product.'],
    ['Visit the Show Room', 'View selected products at Vanderbijlpark, Gauteng and speak with the team about your project.'],
    ['Direct Product Support', 'Contact Fire & Dine for product enquiries, quotation requests, delivery questions and technical assistance.']
  ];
  if (editorial[path] && !['/', '/about'].includes(path)) {
    const section = document.createElement('section');
    section.className = path === '/installation' ? 'section editorial-copy installation-accordion' : 'section editorial-copy';
    section.innerHTML = path === '/installation'
      ? `<div class="shell"><div class="fd-installation-accordion">${editorial[path].map(([heading, copy], index) => { const buttonId=`installation-topic-${index + 1}-button`,panelId=`installation-topic-${index + 1}-panel`,expanded=index<2; return `<article class="fd-installation-accordion-item"><h2><button id="${buttonId}" type="button" aria-expanded="${expanded}" aria-controls="${panelId}"><span>${heading}</span><i aria-hidden="true">${expanded ? '−' : '+'}</i></button></h2><div id="${panelId}" class="fd-installation-accordion-panel" role="region" aria-labelledby="${buttonId}"${expanded ? '' : ' hidden'}><p>${copy}</p></div></article>`; }).join('')}</div></div>`
      : `<div class="shell"><div class="editorial-grid">${editorial[path].map(([heading, copy]) => `<article class="content-box"><h2>${heading}</h2><p>${copy}</p></article>`).join('')}</div></div>`;
    if (path === '/installation') {
      section.querySelectorAll('.fd-installation-accordion-item button').forEach(button => button.addEventListener('click', () => {
        const panel = section.querySelector(`#${button.getAttribute('aria-controls')}`);
        const expanded = button.getAttribute('aria-expanded') === 'true';
        button.setAttribute('aria-expanded', String(!expanded));
        if (panel) panel.hidden = expanded;
        const icon = button.querySelector('i'); if (icon) icon.textContent = expanded ? '+' : '−';
      }));
    }
    const main = document.querySelector('main');
    const closingSection = main?.querySelector('.cta, .newsletter');
    if (closingSection) main.insertBefore(section, closingSection);
    else main?.append(section);
  }

  const nav = document.querySelector('.nav');
  const links = [['/', 'Home'], ['/about', 'About Us'], ['/shop', 'Shop'], ['/installation', 'Installation'], ['/gallery', 'Gallery'], ['/contact', 'Contact Us']];
  if (nav) { nav.setAttribute('aria-label', 'Primary navigation'); nav.innerHTML = links.map(([href, label]) => `<a class="${path === href ? 'active' : ''}" href="${href}"${path === href ? ' aria-current="page"' : ''}>${label}</a>`).join(''); }
  const header = document.querySelector('.header');
  document.querySelectorAll('.logo').forEach(logo => { logo.href = '/'; logo.setAttribute('aria-label', 'Fire & Dine home'); });
  if (header && !header.querySelector('.utility-bar')) {
    header.insertAdjacentHTML('afterbegin', '<div class="utility-bar"><div class="shell"><a href="tel:+27834381485"><i class="fas fa-phone-alt"></i>083 438 1485</a><a href="mailto:Info@fireanddine.co.za"><i class="fas fa-envelope"></i>Info@fireanddine.co.za</a><span><i class="fas fa-map-marker-alt"></i>Vanderbijlpark, Gauteng</span><strong>Family Time Since 2013 <b>•</b> Nationwide Delivery</strong></div></div>');
  }

  const menuButton = document.querySelector('.menu-btn');
  if (nav && menuButton) { if (!nav.id) nav.id = 'primary-navigation'; menuButton.setAttribute('aria-controls', nav.id); }
  menuButton?.addEventListener('click', () => {
    nav?.classList.toggle('open');
    menuButton.setAttribute('aria-expanded', String(nav?.classList.contains('open')));
    menuButton.setAttribute('aria-label', nav?.classList.contains('open') ? 'Close navigation' : 'Open navigation');
    document.body.classList.toggle('menu-open', Boolean(nav?.classList.contains('open')));
  });
  addEventListener('scroll', () => header?.classList.toggle('scrolled', scrollY > 24), { passive: true });
  document.querySelectorAll('.nav a').forEach(link => link.addEventListener('click', () => {
    nav?.classList.remove('open');
    menuButton?.setAttribute('aria-expanded', 'false');
    document.body.classList.remove('menu-open');
  }));
  addEventListener('keydown', event => { if (event.key === 'Escape' && nav?.classList.contains('open')) { nav.classList.remove('open'); document.body.classList.remove('menu-open'); menuButton?.setAttribute('aria-expanded', 'false'); menuButton?.focus(); } });

  if (path !== '/') {
    const hero = document.querySelector('.page-hero');
    const currentLabel = links.find(([href]) => href === path)?.[1];
    if (hero && currentLabel && !hero.querySelector('.breadcrumbs')) {
      const breadcrumbs = document.createElement('nav');
      const home = document.createElement('a');
      const separator = document.createElement('span');
      const current = document.createElement('span');
      breadcrumbs.className = 'breadcrumbs shell';
      breadcrumbs.setAttribute('aria-label', 'Breadcrumb');
      home.href = '/';
      home.textContent = 'Home';
      separator.setAttribute('aria-hidden', 'true');
      separator.textContent = '›';
      current.setAttribute('aria-current', 'page');
      current.textContent = currentLabel;
      breadcrumbs.append(home, separator, current);
      hero.prepend(breadcrumbs);
    }
  }

  if (path === '/contact') {
    const form = document.querySelector('.content-box form.form-grid:not([data-static-contact])');
    if (form) {
      form.classList.add('quote-wizard');
      form.innerHTML = '<div class="quote-progress full"><span></span></div><p class="quote-step-label full">Step <b>1</b> of 3</p><fieldset class="quote-step full"><legend>What are you interested in?</legend><label>Range of interest<select name="range" class="form-control" required><option value="">Choose a range</option><option>DIY pizza oven</option><option>Countertop oven</option><option>Mobile / Premium Mobile</option><option>Steel range</option><option>Commercial Pre-Fabricato</option><option>Commercial Neapolitan</option><option>Forge fireplace</option><option>StoneSkin</option><option>Custom braai / boma fabrication</option></select></label><label>Preferred finish<input name="finish" class="form-control" placeholder="Texture, brick-face, smooth colour, mosaic or unsure"></label></fieldset><fieldset class="quote-step full" hidden><legend>Tell us about the project</legend><label>Delivery address<input name="delivery" class="form-control" required autocomplete="street-address"></label><label>Installation required?<select name="installation" class="form-control" required><option>Yes</option><option>No</option><option>Unsure</option></select></label><label>Timeline<select name="timeline" class="form-control"><option>As soon as possible</option><option>Within 1–3 months</option><option>Within 3–6 months</option><option>Researching options</option></select></label></fieldset><fieldset class="quote-step full" hidden><legend>How can we reach you?</legend><label>Full name<input name="name" class="form-control" required autocomplete="name"></label><label>Email<input name="email" class="form-control" type="email" required autocomplete="email"></label><label>Contact number<input name="phone" class="form-control" type="tel" required autocomplete="tel"></label></fieldset><div class="wizard-actions full"><button class="btn btn-outline quote-back" type="button" hidden>Back</button><button class="btn btn-gold quote-next" type="button">Continue</button><button class="btn btn-gold quote-submit" type="submit" hidden>Open Quote in WhatsApp</button></div>';
      const steps = [...form.querySelectorAll('.quote-step')]; let current = 0;
      const render = () => { steps.forEach((step, index) => { step.hidden = index !== current; }); form.querySelector('.quote-step-label b').textContent = current + 1; form.querySelector('.quote-progress span').style.width = `${((current + 1) / steps.length) * 100}%`; form.querySelector('.quote-back').hidden = current === 0; form.querySelector('.quote-next').hidden = current === steps.length - 1; form.querySelector('.quote-submit').hidden = current !== steps.length - 1; };
      form.querySelector('.quote-next').addEventListener('click', () => { if ([...steps[current].querySelectorAll('[required]')].every(field => field.reportValidity())) { current++; render(); } });
      form.querySelector('.quote-back').addEventListener('click', () => { current--; render(); });
      form.addEventListener('submit', event => { event.preventDefault(); const data=new FormData(form); const msg=`Fire & Dine quote request%0A%0AName: ${encodeURIComponent(data.get('name')||'')}%0AContact: ${encodeURIComponent(data.get('phone')||'')}%0AEmail: ${encodeURIComponent(data.get('email')||'')}%0ADelivery: ${encodeURIComponent(data.get('delivery')||'')}%0ARange: ${encodeURIComponent(data.get('range')||'')}%0AFinish: ${encodeURIComponent(data.get('finish')||'Not specified')}%0AInstallation: ${encodeURIComponent(data.get('installation')||'')}%0ATimeline: ${encodeURIComponent(data.get('timeline')||'')}`; window.open(`https://wa.me/27834381485?text=${msg}`,'_blank','noopener'); }); render();
    }
  }
    const contactForm = document.querySelector('#contact-form');
  if (contactForm) {
    const status = contactForm.querySelector('.form-status');
    const submit = contactForm.querySelector('[type="submit"]');
    let submitting = false;
    contactForm.addEventListener('submit', async event => {
      event.preventDefault();
      status.className = 'form-status full'; status.textContent = '';
      if (submitting) return;
      if (contactForm.elements.website.value) { status.classList.add('error'); status.textContent = 'We could not prepare this enquiry. Please refresh the page and try again.'; return; }
      if (!contactForm.checkValidity()) { contactForm.reportValidity(); status.classList.add('error'); status.textContent = 'Please complete the required fields before continuing.'; return; }
      const attachment = contactForm.elements.attachment.files[0];
      if (attachment && attachment.size > 10 * 1024 * 1024) { status.classList.add('error'); status.textContent = 'The selected file is larger than 10 MB. Please choose a smaller file.'; contactForm.elements.attachment.focus(); return; }
      submitting = true; submit.disabled = true; submit.textContent = 'Sending…';
      const data = new FormData(contactForm);
      data.append('attribution', localStorage.getItem('x3_latest_attribution') || '{}');
      try {
        const token = await fetch('/api/enquiries', { headers: { Accept: 'application/json' } }).then(response => response.json());
        const response = await fetch('/api/enquiries', { method: 'POST', body: data, headers: { Accept: 'application/json', 'X-CSRF-Token': token.csrf_token } });
        const result = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(result.error || 'Your enquiry could not be sent. Please try again.');
        contactForm.reset();
        status.classList.add('success'); status.textContent = `Thank you. Your enquiry was sent successfully. Reference: ${result.reference}`;
        document.dispatchEvent(new CustomEvent('x3:lead-success',{detail:{event_id:result.tracking_event_id,lead_reference:result.reference}}));
      } catch (error) {
        status.classList.add('error'); status.textContent = error.message || 'Your enquiry could not be sent. Please call or WhatsApp us.';
      } finally {
        submitting = false; submit.disabled = false; submit.textContent = 'Send Enquiry';
      }
    });
  }

  if (path === '/') {
    document.querySelectorAll('.range-overview .knowledge-grid .text-link').forEach(link => {
      link.textContent = 'EXPLORE';
      link.classList.add('fd-range-explore-link');
    });
  }

  if (path === '/shop') {
    const shopSection = document.querySelector('.products')?.closest('.section'); if (shopSection) { shopSection.id = 'pizza-ovens'; shopSection.insertAdjacentHTML('afterbegin', '<span id="commercial-ovens" class="anchor-target" aria-hidden="true"></span><span id="fireplaces" class="anchor-target" aria-hidden="true"></span><span id="accessories" class="anchor-target" aria-hidden="true"></span>'); }
    const products = [...document.querySelectorAll('.products .product')];
    const seen = new Set();
    products.forEach(product => { const key = `${product.querySelector('h3')?.textContent.trim()}|${product.querySelector('.price')?.textContent.trim()}`; if (seen.has(key)) product.remove(); else seen.add(key); });
    const search = document.querySelector('.toolbar input[type="search"]');
    const category = document.querySelector('.toolbar select');
    const sort = document.querySelectorAll('.toolbar select')[1];
    search?.setAttribute('aria-label','Search products'); category?.setAttribute('aria-label','Filter by product family'); sort?.setAttribute('aria-label','Sort products');
    products.forEach(product => { const heading=product.querySelector('h3')?.textContent || ''; const info=product.querySelector('.product-info'); if(info && !info.querySelector('.best-for')) info.insertAdjacentHTML('afterbegin',`<span class="best-for">Best for: ${/fireplace/i.test(heading)?'home heating':'live-fire cooking and entertaining'}</span>`); });
    const filterProducts = () => { const term = search?.value.trim().toLowerCase() || ''; const selected = category?.value.toLowerCase() || 'all categories'; document.querySelectorAll('.products .product').forEach(product => { const text = product.textContent.toLowerCase(); const categoryMatch = selected === 'all categories' || text.includes(selected.replace(/s$/, '')); product.hidden = !text.includes(term) || !categoryMatch; }); };
    search?.addEventListener('input', filterProducts); category?.addEventListener('change', filterProducts);
    sort?.addEventListener('change', () => { const grid = document.querySelector('.products'); const cards = [...grid.querySelectorAll('.product')]; if (sort.selectedIndex > 0) cards.sort((a, b) => { const price = card => Number(card.querySelector('.price')?.textContent.replace(/[^0-9.]/g, '') || 0); return sort.selectedIndex === 1 ? price(a) - price(b) : price(b) - price(a); }).forEach(card => grid.append(card)); });
    [...document.querySelectorAll('button')].find(button => button.textContent.trim() === 'Load more')?.remove();
    [...document.querySelectorAll('.section,.cards,.content-box')].filter(element=>/find the right product for your space|authentic wood-fired cooking starts here|delivery coordinated according to your location|warmth with lasting visual impact/i.test(element.textContent)).forEach(element=>{const section=element.closest('.section');(section||element).remove();});
    const main = document.querySelector('main');
    const guidance = document.createElement('section'); guidance.className = 'cta'; guidance.innerHTML = '<div class="shell"><span class="eyebrow">Product guidance</span><h2>Need Help Choosing?</h2><p>Tell us about your space, residential or commercial use, and delivery location.</p><div class="actions"><a class="btn btn-gold" href="/contact">Contact Us</a><a class="btn btn-outline" href="/compare">Compare Products</a><a class="btn btn-outline" href="/installation">View Installation Information</a></div></div>'; main?.append(guidance);
  }
  if (path === '/product') {
    const productName = document.querySelector('.product-detail h1, main h1')?.textContent.trim() || 'Fire & Dine product';
    const productPanel = document.querySelector('.product-detail, .two-col');
    productPanel?.insertAdjacentHTML('beforeend', `<div class="product-support"><a class="btn btn-outline" href="https://wa.me/27834381485?text=${encodeURIComponent(`Hello Fire & Dine, I would like information about ${productName}.`)}" target="_blank" rel="noopener noreferrer">WhatsApp About This Product</a><a class="btn btn-outline" href="/contact?product=${encodeURIComponent(productName)}">Request a Delivery Quote</a></div>`);
    const productResource = document.createElement('section'); productResource.className = 'section product-resources-section'; productResource.innerHTML = '<div class="shell"><div class="section-head"><span class="eyebrow">Product resources</span><h2>Compare, Plan and Ask</h2><p>Use the available website guidance while detailed product documents are managed through the backend.</p></div><div class="cards"><article class="content-box"><h2>Compare<br>Products</h2><p>Compare the products and prices currently published online.</p><a class="text-link" href="/compare">Compare Models →</a></article><article class="content-box"><h2>Installation<br>Information</h2><p>Review general preparation, curing and maintenance guidance.</p><a class="text-link" href="/installation">View Installation Information →</a></article><article class="content-box"><h2>Product<br>Brochure</h2><p>Access the brochure when it has been published through the website backend.</p><a class="text-link" data-brochure-download href="/contact?subject=brochure">Request the Brochure →</a></article></div></div>'; document.querySelector('main')?.append(productResource);
  }
  document.querySelectorAll('.thumbs img').forEach(thumb => thumb.addEventListener('click', () => {
    const main = document.querySelector('.gallery-main');
    if (main) { const previous = main.src; main.src = thumb.src; thumb.src = previous; }
  }));

  const duplicateFooters = [...document.querySelectorAll('footer.footer')];
  let footer = duplicateFooters.shift() || document.querySelector('.footer');
  duplicateFooters.forEach(duplicate => duplicate.remove());
  if (!footer) {
    footer = document.createElement('footer');
    footer.className = 'footer';
    (document.querySelector('.page') || document.body).append(footer);
  }
  footer.classList.add('home-footer-standard');
  footer.dataset.footerStandard = 'home';
  footer.innerHTML = `<div class="shell footer-grid footer-reference-grid"><section class="footer-col footer-brand"><img class="footer-logo" src="assets/images/logo/fire-dine-footer-logo.webp" alt="Fire &amp; Dine"><p>Premium fireplaces, pizza ovens and outdoor living solutions built for warmth, style and unforgettable moments.</p><div class="trust-points" aria-label="Fire &amp; Dine values"><span><i class="fas fa-shield-alt" aria-hidden="true"></i><b>Premium<br>Quality</b></span><span><i class="fas fa-fire" aria-hidden="true"></i><b>Built for<br>Every Home</b></span><span><i class="fas fa-tools" aria-hidden="true"></i><b>Expert<br>Installation</b></span></div></section><nav class="footer-col footer-links" aria-label="Footer quick links"><h3>Quick Links</h3><div class="footer-link-list">${links.map(([href,label]) => `<a href="${href}">${label}</a>`).join('')}<a href="/compare">Compare Products</a><a href="/faqs">Frequently Asked Questions</a></div></nav><nav class="footer-col footer-policies" aria-label="Policies"><h3>Policy</h3><div class="footer-link-list"><a href="/privacy-policy">Privacy Policy</a><a href="/terms">Terms of Service</a></div></nav><section class="footer-col footer-contact"><h3>Contact Us</h3><div class="footer-contact-list"><p><i class="fas fa-map-marker-alt" aria-hidden="true"></i><span>Vanderbijlpark, Gauteng</span></p><a href="tel:+27834381485" data-track="phone_click"><i class="fas fa-phone" aria-hidden="true"></i><span>083 438 1485</span></a><a href="mailto:Info@fireanddine.co.za" data-track="email_click"><i class="fas fa-envelope" aria-hidden="true"></i><span>Info@fireanddine.co.za</span></a></div><div class="socials" aria-label="Fire &amp; Dine social channels"><span class="social-placeholder" aria-label="Facebook"><i class="fab fa-facebook-f" aria-hidden="true"></i></span><span class="social-placeholder" aria-label="Instagram"><i class="fab fa-instagram" aria-hidden="true"></i></span><span class="social-placeholder" aria-label="YouTube"><i class="fab fa-youtube" aria-hidden="true"></i></span></div></section></div><div class="copyright">Copyright © 2026 Fire &amp; Dine. All rights reserved. Designed and Powered by <a href="https://x3web.co.za/" target="_blank" rel="noopener noreferrer">X3WEB</a>.</div>`;

  const socialDestinations = [
    ['Facebook', 'https://www.facebook.com/www.fireanddine.co.za'],
    ['Instagram', 'https://www.instagram.com/fireanddinepizzaovens'],
    ['YouTube', 'https://www.youtube.com/@FireandDine']
  ];
  footer.querySelectorAll('.social-placeholder').forEach((placeholder, index) => {
    const [label, href] = socialDestinations[index] || [];
    if (!label || !href) return;
    const link = document.createElement('a');
    link.className = placeholder.className;
    link.href = href;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    link.setAttribute('aria-label', `Visit Fire & Dine on ${label}`);
    link.append(...placeholder.childNodes);
    placeholder.replaceWith(link);
  });

 if (path === '/about' && document.body.dataset.includeFaq === 'true' && !document.querySelector('#faqs')) {
    const faqItems = [
      ['What types of pizza ovens do you supply?', 'We supply residential, commercial, built-in, countertop, mobile and custom-finished wood-fired ovens.'],
      ['Do you sell fireplaces and accessories?', 'Yes. Our range includes freestanding and built-in fireplaces, cooking tools, replacement parts and fire-management accessories.'],
      ['How do I choose the correct oven size?', 'Our team will consider your available space, expected cooking volume and residential or commercial requirements.'],
      ['Can I request a formal quotation?', 'Yes. Contact us with the product, delivery location and installation details for a written quotation.'],
      ['Do you offer nationwide delivery?', 'Delivery can be arranged across South Africa, subject to product size, destination and unloading requirements.'],
      ['Do you provide professional installation?', 'Yes. We install residential and commercial ovens, fireplaces and related flue systems.'],
      ['How often should an oven or fireplace be serviced?', 'Inspection frequency depends on use, but regular cleaning and periodic safety checks help maintain reliable performance.'],
      ['Can you repair damaged ovens?', 'Yes. We assess and repair fire bricks, doors, insulation, chimneys, flues and compatible internal components.'],
      ['What type of wood should I use?', 'Use dry, seasoned firewood for cleaner combustion, reliable heat and reduced smoke.'],
      ['Do your products include a warranty?', 'Warranty coverage varies by product. Our team will confirm the applicable product and workmanship terms before purchase.']
    ];
    const section = document.createElement('section');
    section.id = 'faqs';
    section.className = 'section faq-section';
    section.innerHTML = `<div class="shell"><div class="section-head"><span class="eyebrow">Frequently Asked Questions</span><h2>Everything You Need to Know</h2><p>Find answers about our products, orders, delivery, installation, servicing and repairs.</p></div><div class="faq-list">${faqItems.map(([question, answer]) => `<details><summary>${question}<i class="fas fa-plus" aria-hidden="true"></i></summary><p>${answer}</p></details>`).join('')}</div><div class="faq-cta"><h2>Still Have Questions?</h2><div class="actions"><a class="btn btn-gold" href="/contact">Contact Us</a><a class="btn btn-outline" href="tel:+27834381485">Call Now</a></div></div></div>`;
    document.querySelector('main')?.append(section);
    section.querySelectorAll('details').forEach(detail => detail.addEventListener('toggle', () => detail.querySelector('summary').setAttribute('aria-expanded', String(detail.open))));
  }

  const eyebrowIcon = '<img src="/assets/images/icon/fire-eyebrow-icon.svg" alt="" class="eyebrow-icon" aria-hidden="true">';
  document.querySelectorAll('.eyebrow, .service-kicker, .install-guidance-kicker').forEach(eyebrow => {
    if (eyebrow.querySelector('.eyebrow-icon')) return;
    const label = eyebrow.textContent.trim();
    eyebrow.textContent = '';
    eyebrow.insertAdjacentHTML('beforeend', `${eyebrowIcon}<span>${label}</span>${eyebrowIcon}`);
  });
  document.querySelectorAll('.cgs-kicker-badge').forEach(badge => {
    badge.innerHTML = eyebrowIcon;
  });

  const scrollTopButton = document.createElement('button');
  scrollTopButton.className = 'site-scroll-top';
  scrollTopButton.type = 'button';
  scrollTopButton.setAttribute('aria-label', 'Scroll to top');
  scrollTopButton.innerHTML = '<i class="fas fa-arrow-up" aria-hidden="true"></i>';
  document.body.append(scrollTopButton);
  const floatingWhatsApp = document.createElement('a');
  floatingWhatsApp.className = 'floating-whatsapp';
  floatingWhatsApp.href = 'https://wa.me/27834381485?text=Hi%20Fire%20%26%20Dine%2C%20I%20would%20like%20to%20enquire.';
  floatingWhatsApp.target = '_blank';
  floatingWhatsApp.rel = 'noopener noreferrer';
  floatingWhatsApp.setAttribute('aria-label', 'Chat with Fire & Dine on WhatsApp');
  floatingWhatsApp.innerHTML = '<i class="fab fa-whatsapp" aria-hidden="true"></i>';
  document.body.append(floatingWhatsApp);
  const updateScrollTop = () => scrollTopButton.classList.toggle('visible', scrollY > 420);
  scrollTopButton.addEventListener('click', () => scrollTo({ top: 0, behavior: 'smooth' }));
  addEventListener('scroll', updateScrollTop, { passive: true });
  updateScrollTop();

  const mobileConversion = document.createElement('nav');
  mobileConversion.className = 'mobile-conversion';
  mobileConversion.setAttribute('aria-label', 'Quick contact');
  mobileConversion.innerHTML = '<a href="tel:+27834381485"><i class="fas fa-phone" aria-hidden="true"></i>Call</a><a href="https://wa.me/27834381485" target="_blank" rel="noopener noreferrer"><i class="fab fa-whatsapp" aria-hidden="true"></i>WhatsApp</a><a href="/contact"><i class="fas fa-file-signature" aria-hidden="true"></i>Request Quote</a>';
  document.body.append(mobileConversion);

  const ctaContent = {
    consultation:['cta-01-design-consultation','Consultation','Speak to a Fire & Dine Expert','Get tailored guidance on the right fireplace, pizza oven, or outdoor-living solution for your space.','Book a Consultation','/contact','Contact Us','/contact'],
    shop:['cta-02-shop-pizza-ovens','Explore the collection','Explore Premium Pizza Ovens','Discover ovens designed for entertaining, performance, and unforgettable meals.','Shop Pizza Ovens','/shop#pizza-ovens','View All Products','/shop'],
    showroom:['cta-03-visit-showroom','Project inspiration','Explore the Fire & Dine Gallery','See residential, commercial and lifestyle inspiration, then discuss a similar space with our team.','View the Gallery','/gallery','Request a Similar Installation','/contact?subject=similar-installation'],
    installation:['cta-04-book-installation','Installation support','Book Expert Installation Support','From planning to final placement, get help preparing for your oven or fireplace installation.','Request Installation Help','/contact?product=Installation%20support','View Installation Guide','/installation'],
    quote:['cta-05-request-quote','Start your project','Ready to Create Your Perfect Fire & Dine Space?','Request a personalised quote for fireplaces, pizza ovens, and outdoor-living solutions.','Request a Quote','/contact','Speak to an Expert','/contact']
  };
  const ctaBanner = type => { const item=ctaContent[type]; const section=document.createElement('section');section.className=`image-cta image-cta-${type}`;section.innerHTML=`<picture class="image-cta-media"><source type="image/avif" srcset="assets/images/fire-and-dine/cta/${item[0]}-640.avif 640w, assets/images/fire-and-dine/cta/${item[0]}-960.avif 960w, assets/images/fire-and-dine/cta/${item[0]}-1440.avif 1440w, assets/images/fire-and-dine/cta/${item[0]}-1916.avif 1916w" sizes="100vw"><source type="image/webp" srcset="assets/images/fire-and-dine/cta/${item[0]}-640.webp 640w, assets/images/fire-and-dine/cta/${item[0]}-960.webp 960w, assets/images/fire-and-dine/cta/${item[0]}-1440.webp 1440w, assets/images/fire-and-dine/cta/${item[0]}-1916.webp 1916w" sizes="100vw"><img src="assets/images/fire-and-dine/cta/${item[0]}.png" width="1916" height="821" alt="" loading="lazy" decoding="async"></picture><div class="shell image-cta-content"><span class="eyebrow">${item[1]}</span><h2>${item[2]}</h2><p>${item[3]}</p><div class="actions"><a class="btn btn-gold" href="${item[5]}">${item[4]}</a><a class="image-cta-link" href="${item[7]}">${item[6]} →</a></div></div>`;return section; };
  const appendCtas = (...types) => types.forEach(type=>pageMain?.append(ctaBanner(type)));
  if (false && path === '/') {
    const categories=pageMain?.querySelector('.cream'); if(categories)categories.after(ctaBanner('shop'));
    const productSection=[...pageMain?.children||[]].find(section=>section.querySelector?.('.products')); if(productSection)productSection.after(ctaBanner('consultation'));
    const splits=[...pageMain?.querySelectorAll(':scope > .split')||[]]; if(splits[0])splits[0].after(ctaBanner('showroom')); if(splits[1])splits[1].after(ctaBanner('installation'));
    const galleryPreview=document.createElement('section'); galleryPreview.className='section home-gallery-preview'; galleryPreview.innerHTML='<div class="shell"><div class="section-head"><span class="eyebrow">Gallery preview</span><h2>Imagine Your Own Fire &amp; Dine Space</h2><p>Explore product and lifestyle inspiration across residential, commercial, compact and fireplace settings.</p></div><div class="gallery-preview-grid"><a href="/gallery"><img src="assets/images/fire-and-dine/heroes/hero-05-mountain-terrace-640.webp" width="640" height="274" loading="lazy" alt="Pizza oven on a mountain terrace"></a><a href="/gallery"><img src="assets/images/fire-and-dine/heroes/hero-01-social-dining-640.webp" width="640" height="274" loading="lazy" alt="Guests dining beside a glowing pizza oven"></a><a href="/gallery"><img src="assets/images/fire-and-dine/heroes/hero-04-product-showcase-640.webp" width="640" height="274" loading="lazy" alt="Premium pizza oven product display"></a><a href="/gallery"><img src="assets/images/fire-and-dine/categories/fire-and-dine-fireplaces-category-640.webp" width="640" height="360" loading="lazy" alt="Modern fireplace in a warm interior"></a><a href="/gallery"><img src="assets/images/fire-and-dine/categories/fire-and-dine-pizza-ovens-category-640.webp" width="640" height="360" loading="lazy" alt="Wood-fired pizza oven in an outdoor area"></a><a href="/gallery"><img src="assets/images/fire-and-dine/categories/fire-and-dine-accessories-category-640.webp" width="640" height="360" loading="lazy" alt="Pizza oven tools and accessories"></a></div><div class="actions centred-actions"><a class="btn btn-gold" href="/gallery">View the Gallery</a></div></div>'; pageMain?.append(galleryPreview);
    const finalConversion=document.createElement('section'); finalConversion.className='cta home-final-conversion'; finalConversion.innerHTML='<div class="shell"><span class="eyebrow">Your next step</span><h2>Ready to Plan Your Fire &amp; Dine Space?</h2><p>Share your product interest, available space and delivery location for relevant guidance.</p><div class="actions"><a class="btn btn-gold" href="/contact?subject=quote" data-track="quote_start">Request a Quote</a><a class="btn btn-outline" href="https://wa.me/27834381485">WhatsApp Our Team</a></div></div>'; pageMain?.append(finalConversion);
    // The previous homepage CTA/newsletter stack is intentionally omitted.
  }
  if (false && path === '/about') appendCtas('consultation');
  // Every page already ships with its intended closing CTA. Remove any legacy or
  // dynamically-added duplicates, retain one, and keep it directly before the footer.
  if (pageMain) {
    const closingCtas = [...pageMain.children].filter(section =>
      section.matches('.cta, .newsletter, .image-cta')
    );
    const finalCta = closingCtas.find(section => section.classList.contains('site-final-cta'))
      || closingCtas.at(-1);
    closingCtas.forEach(section => { if (section !== finalCta) section.remove(); });
    if (finalCta) pageMain.append(finalCta);
  }
  document.querySelectorAll('main .cta .btn, main .image-cta .btn, main .image-cta .image-cta-link, main .faq-cta .btn, main .maintenance-cta .btn').forEach(button => {
    button.classList.remove('image-cta-link');
    button.classList.remove('btn-outline');
    button.classList.add('btn-gold', 'fd-home-cta-button');
  });
  applySectionRhythm();

  if (path === '/gallery') {
    const cards = [...document.querySelectorAll('.gallery-card')];
    const filterButtons = [...document.querySelectorAll('[data-gallery-filter]')];
    filterButtons.forEach(button => button.addEventListener('click', () => {
      const filter = button.dataset.galleryFilter;
      filterButtons.forEach(item => { const active = item === button; item.classList.toggle('active', active); item.setAttribute('aria-pressed', String(active)); });
      cards.forEach(card => { card.hidden = filter !== 'all' && card.dataset.galleryCategory !== filter; });
    }));
    const dialog = document.querySelector('.gallery-lightbox');
    const openers = [...document.querySelectorAll('.gallery-open')];
    let currentGalleryIndex = 0;
    const showGalleryImage = index => {
      currentGalleryIndex = (index + openers.length) % openers.length;
      const opener = openers[currentGalleryIndex];
      const image = dialog?.querySelector('img');
      if (image) { image.src = opener.dataset.full; image.alt = opener.querySelector('img')?.alt || ''; }
      const caption = dialog?.querySelector('figcaption'); if (caption) caption.textContent = opener.dataset.caption || '';
    };
    openers.forEach((opener, index) => opener.addEventListener('click', () => { showGalleryImage(index); dialog?.showModal(); window.dataLayer?.push({ event: 'gallery_project_open', gallery_category: opener.closest('.gallery-card')?.dataset.galleryCategory }); }));
    dialog?.querySelector('.gallery-close')?.addEventListener('click', () => dialog.close());
    dialog?.querySelector('.gallery-prev')?.addEventListener('click', () => showGalleryImage(currentGalleryIndex - 1));
    dialog?.querySelector('.gallery-next')?.addEventListener('click', () => showGalleryImage(currentGalleryIndex + 1));
    dialog?.addEventListener('click', event => { if (event.target === dialog) dialog.close(); });
    dialog?.addEventListener('keydown', event => { if (event.key === 'ArrowLeft') showGalleryImage(currentGalleryIndex - 1); if (event.key === 'ArrowRight') showGalleryImage(currentGalleryIndex + 1); });
  }

  const campaignKeys = ['utm_source','utm_medium','utm_campaign','utm_content','utm_term'];
  const campaign = Object.fromEntries(campaignKeys.map(key => [key, new URLSearchParams(location.search).get(key)]).filter(([, value]) => value));
  let savedCampaign = {};
  try { if (Object.keys(campaign).length) sessionStorage.setItem('fireDineCampaign', JSON.stringify(campaign)); savedCampaign = JSON.parse(sessionStorage.getItem('fireDineCampaign') || '{}'); } catch { savedCampaign = campaign; }
  if (Object.keys(savedCampaign).length) document.querySelectorAll('a[href^="/contact"]').forEach(link => { const url = new URL(link.href, location.origin); Object.entries(savedCampaign).forEach(([key,value]) => { if (!url.searchParams.has(key)) url.searchParams.set(key,value); }); link.href = `${url.pathname}${url.search}${url.hash}`; });
  document.addEventListener('click', event => {
    const target = event.target.closest('a,button'); if (!target) return;
    let action = target.dataset.track || '';
    const href = target.getAttribute('href') || '';
    if (!action && href.startsWith('tel:')) action = 'phone_click';
    if (!action && href.includes('wa.me')) action = 'whatsapp_click';
    if (!action && href.startsWith('mailto:')) action = 'email_click';
    if (!action && href.includes('maps.google')) action = 'directions_click';
    if (!action && target.classList.contains('add-cart')) action = 'add_to_cart';
    if (action) { window.dataLayer = window.dataLayer || []; window.dataLayer.push({ event: action, link_text: target.textContent.trim(), page_path: location.pathname, ...savedCampaign }); }
  });
  if (path === '/thank-you') { window.dataLayer = window.dataLayer || []; window.dataLayer.push({ event: 'lead_complete', page_path: location.pathname, ...savedCampaign }); }

  if (path === '/faqs') {
    const faqList=document.querySelector('.faq-list');
    const groupedFaqs={Products:[['Which domestic DIY models are available?','Standard, Grande and Superior. The Standard is 930 mm × 820 mm front to back and the Superior is 1200 mm × 1000 mm. Grande dimensions should be confirmed before base construction.'],['What is included with a domestic DIY oven?','Floor insulation, a mild-steel door with a thermometer set into the door, plus a 430 stainless-steel flue and pipe.'],['Do you offer mobile pizza ovens?','Yes. The range includes Mobile Countertop plus Premium Mobile Piccolo, Vivace and Maestro on wheeled steel stands.']],Delivery:[['Do you deliver across South Africa?','Yes. Fire and Dine delivers nationwide. Delivery and installation are quoted separately for each job.'],['Do you supply outside South Africa?','Fire and Dine has completed export work into Zimbabwe and Zambia. Contact the team to discuss current export requirements.']],Installation:[['How long does a DIY oven installation take?','Once the base is prepared, the dome and floor arrive as one fully assembled unit and installation takes approximately one hour.'],['Do you build the oven stand?','No. Fire and Dine supplies recommended stand guidance and may recommend a builder.'],['Does a new oven need curing?','Yes. Single-layer cast refractory domes must be cured to the supplied schedule. Rushing the process can cause thermal differential expansion and cracking.']],Customisation:[['Which finishes are available?','Options include textured coats, brick-face finishes, smooth paint colours and custom mosaic. Commercial domes can include a client logo tiled into the mosaic.'],['What is the Coastal Kit?','An upgrade with aluminium door, aluminium spigot valve, brushed storm cowl and 304 stainless-steel flue pipe.']],Commercial:[['Which commercial ranges are available?','Pre-Fabricato and Neapolitan commercial ranges are confirmed. Hybrid gas-and-wood is available on commercial builds, with the burner fitted and tested before dispatch.'],['How many pizzas can the Neapolitan range handle?','Piccolo 2–3 medium pizzas, Classico 4, Grande 6–7 and Maestro 8–10.']],Fireplaces:[['Which Forge fireplaces are confirmed?','The confirmed range includes TEN, f40, f70, F100, i50 and i120. A previously recorded F120 requires clarification and is not published as a separate confirmed model.']],StoneSkin:[['What is StoneSkin?','A durable decorative stone coating used on Fire and Dine ovens and suited to pool surrounds, patios, entertainment areas, braai and boma walls and feature walls.'],['Which StoneSkin colours are available?','Quartz, Granite, Midnight Black, New Kalahari and Red Glass, in 1.2 mm smooth or 1.6 mm textured aggregate.']],Support:[['How do I get technical help?','WhatsApp 083 438 1485. Fire and Dine provides guidance on curing, operation and flue installation.']]};
    if(faqList) faqList.innerHTML=Object.entries(groupedFaqs).map(([group,items])=>`<section class="faq-group" aria-labelledby="faq-${group.toLowerCase()}"><h2 id="faq-${group.toLowerCase()}">${group}</h2>${items.map(([question,answer])=>`<details><summary>${question}</summary><p>${answer}</p></details>`).join('')}</section>`).join('');
    const faqEntities = [...document.querySelectorAll('.faq-list details')].map(detail => ({ '@type':'Question', name:detail.querySelector('summary')?.textContent.trim(), acceptedAnswer:{ '@type':'Answer', text:detail.querySelector('p')?.textContent.trim() } })).filter(item => item.name && item.acceptedAnswer.text);
    if (faqEntities.length) { const schema=document.createElement('script'); schema.type='application/ld+json'; schema.textContent=JSON.stringify({ '@context':'https://schema.org', '@type':'FAQPage', mainEntity:faqEntities }); document.head.append(schema); }
  }
  const structuredData = [{ '@context':'https://schema.org', '@type':['Organization','LocalBusiness'], name:'Fire & Dine (Pty) Ltd', url:'https://fireanddine.co.za/', foundingDate:'2013', telephone:'+27834381485', email:'Info@fireanddine.co.za', address:{ '@type':'PostalAddress', addressLocality:'Vanderbijlpark', addressRegion:'Gauteng', addressCountry:'ZA' } }];
  const breadcrumbItems=[...document.querySelectorAll('.breadcrumbs a, .breadcrumbs [aria-current="page"]')].map((item,index)=>({ '@type':'ListItem', position:index+1, name:item.textContent.trim(), item:item.href||location.href }));
  if(breadcrumbItems.length>1) structuredData.push({ '@context':'https://schema.org', '@type':'BreadcrumbList', itemListElement:breadcrumbItems });
  if(path==='/product') { const name=document.querySelector('.product-detail h1')?.textContent.trim(); const image=document.querySelector('.gallery-main')?.src; if(name) structuredData.push({ '@context':'https://schema.org', '@type':'Product', name, image, brand:{'@type':'Brand',name:'Fire & Dine'} }); }
  structuredData.forEach(data=>{const script=document.createElement('script');script.type='application/ld+json';script.textContent=JSON.stringify(data);document.head.append(script);});

  document.querySelectorAll('[data-brochure-download]').forEach(link => { if (brochureUrl) { link.href = brochureUrl; link.setAttribute('download', ''); link.textContent = 'Download the Brochure →'; } });
  applySectionRhythm();
  document.querySelectorAll('[data-year]').forEach(year => { year.textContent = String(new Date().getFullYear()); });
});

// Shared database-product card used by the Shop and Related Products grids.
const buildFdProductCard = product => {
  const productUrl = `/product?slug=${encodeURIComponent(product.slug)}`;
  const article = document.createElement('article'); article.className = 'product'; article.dataset.name = String(product.name || '').toLowerCase();
  const media = document.createElement('a'); media.href = productUrl;
  if (product.image_url) { const image = document.createElement('img'); image.src = product.image_url; image.alt = product.name; image.loading = 'lazy'; media.append(image); }
  const info = document.createElement('div'); info.className = 'product-info';
  const category = document.createElement('span'); category.className = 'eyebrow'; category.textContent = product.category || 'Uncategorised';
  const name = document.createElement('h3'); name.textContent = product.name;
  const spec = document.createElement('div'); spec.className = 'spec'; const description = document.createElement('div'); description.innerHTML = product.short_description || ''; spec.textContent = description.textContent.trim() || 'Fire & Dine product';
  const price = document.createElement('div'); price.className = 'price'; const current = product.sale_price || product.regular_price; const min = product.variation_min_price, max = product.variation_max_price; price.textContent = min !== null && min !== undefined ? (Number(min) === Number(max) ? `R${Number(min).toFixed(2)}` : `R${Number(min).toFixed(2)} - R${Number(max).toFixed(2)}`) : (Number(current) > 0 ? `R${Number(current).toFixed(2)}` : 'Request current pricing');
  const actions = document.createElement('div'); actions.className = 'fd-product-actions';
  const details = document.createElement('a'); details.className = 'btn fd-light-gold-outline'; details.href = productUrl; details.textContent = 'View Details';
  const quote = document.createElement('a'); quote.className = 'btn btn-gold'; quote.href = productUrl; quote.textContent = 'Request Quote';
  if (product.product_type !== 'variable') { quote.dataset.addToQuote = ''; quote.dataset.quoteItem = JSON.stringify({product_id:Number(product.id),variation_id:null,name:product.name,image_url:product.image_url,attributes:{},quantity:1}); }
  actions.append(details, quote); info.append(category, name, spec, price, actions); article.append(media, info); return article;
};

// Replace the static catalogue with live MySQL products and filter that verified public response.
document.addEventListener('DOMContentLoaded', async () => {
  if (!/^\/shop(?:\.html)?\/?$/.test(location.pathname)) return;
  const grid = document.querySelector('.products');
  const toolbar = grid?.previousElementSibling?.matches('.toolbar') ? grid.previousElementSibling : document.querySelector('.toolbar');
  if (!grid || !toolbar) return;

  const searchForm = document.createElement('form'); searchForm.className = 'fd-shop-search'; searchForm.setAttribute('role', 'search');
  const searchRow = document.createElement('div'); searchRow.className = 'fd-shop-search-row';
  const search = document.createElement('input'); search.className = 'field'; search.type = 'search'; search.placeholder = 'Search products'; search.setAttribute('aria-label', 'Search products');
  const searchButton = document.createElement('button'); searchButton.className = 'btn btn-gold'; searchButton.type = 'submit'; searchButton.textContent = 'Search';
  const filters = document.createElement('div'); filters.className = 'fd-shop-filter-row';
  const categoryFilter = document.createElement('select'); categoryFilter.className = 'field'; categoryFilter.setAttribute('aria-label', 'Filter by category');
  const featuredFilter = document.createElement('select'); featuredFilter.className = 'field'; featuredFilter.setAttribute('aria-label', 'Filter by featured status');
  featuredFilter.innerHTML = '<option value="all">All Products</option><option value="featured">Featured Products</option>';
  searchRow.append(search, searchButton); filters.append(categoryFilter, featuredFilter); searchForm.append(searchRow, filters); toolbar.replaceChildren(searchForm); toolbar.classList.add('fd-shop-controls');

  const status = document.createElement('div'); status.className = 'fd-shop-status'; status.setAttribute('role', 'status'); status.setAttribute('aria-live', 'polite');
  grid.before(status);
  grid.replaceChildren(); grid.setAttribute('aria-busy', 'true');
  [...grid.parentElement.children].find(element => element !== toolbar && element !== grid && element.querySelector?.('button')?.textContent.trim().toLowerCase() === 'load more')?.remove();

  const showMessage = (message, resettable = false) => {
    const copy = document.createElement('p'); copy.textContent = message;
    status.replaceChildren(copy);
    if (resettable) {
      const reset = document.createElement('button'); reset.className = 'btn fd-light-gold-outline'; reset.type = 'button'; reset.textContent = 'Reset Filters';
      reset.addEventListener('click', () => { search.value = ''; categoryFilter.value = 'all'; featuredFilter.value = 'all'; render(); search.focus(); });
      status.append(reset);
    }
  };

  let catalogue = [];
  const render = () => {
    const term = search.value.trim().toLowerCase();
    const selectedCategory = categoryFilter.value;
    const featuredOnly = featuredFilter.value === 'featured';
    const filtered = catalogue.filter(product => {
      const searchable = `${product.name || ''} ${product.category || ''} ${product.short_description || ''}`.toLowerCase();
      return (!term || searchable.includes(term))
        && (selectedCategory === 'all' || String(product.category_slug || '') === selectedCategory)
        && (!featuredOnly || Number(product.featured) === 1);
    });
    grid.replaceChildren(...filtered.map(buildFdProductCard));
    status.replaceChildren();
    if (!filtered.length) showMessage('No products match your current filters.', true);
  };

  searchForm.addEventListener('submit', event => { event.preventDefault(); render(); });
  search.addEventListener('input', render);
  categoryFilter.addEventListener('change', render);
  featuredFilter.addEventListener('change', render);

  try {
    const response = await fetch('/api/products', { headers: { Accept: 'application/json' } });
    if (!response.ok) throw new Error('Products unavailable');
    const payload = await response.json(); catalogue = Array.isArray(payload.products) ? payload.products : [];
    const categories = [...new Map(catalogue.filter(product => product.category_slug).map(product => [String(product.category_slug), String(product.category || product.category_slug)])).entries()].sort((a,b) => a[1].localeCompare(b[1]));
    categoryFilter.replaceChildren(new Option('All Categories', 'all'), ...categories.map(([value,label]) => new Option(label, value)));
    if (!catalogue.length) showMessage('No products are currently available.'); else render();
  } catch (_) {
    grid.replaceChildren(); showMessage('Products are temporarily unavailable. Please try again shortly.');
  } finally {
    grid.removeAttribute('aria-busy');
  }
});

// Populate the existing product-detail design from the backend, including valid variation pricing.
document.addEventListener('DOMContentLoaded', async () => {
  if (!/^\/product(?:\.html)?\/?$/.test(location.pathname)) return;
  const slug = new URLSearchParams(location.search).get('slug');
  const section = document.querySelector('.product-detail');
  if (!slug || !section) return;
  const safeProductHtml = value => {
    const template = document.createElement('template');
    template.innerHTML = String(value || '');
    const allowed = new Set(['P', 'BR', 'STRONG', 'EM', 'B', 'I', 'UL', 'OL', 'LI', 'H2', 'H3', 'H4', 'A']);
    [...template.content.querySelectorAll('*')].forEach(element => {
      if (!allowed.has(element.tagName)) {
        element.replaceWith(...element.childNodes);
        return;
      }
      [...element.attributes].forEach(attribute => {
        if (element.tagName === 'A' && attribute.name.toLowerCase() === 'href') {
          if (!/^(?:https?:\/\/|mailto:|tel:|\/|#)/i.test(attribute.value)) element.removeAttribute(attribute.name);
        } else {
          element.removeAttribute(attribute.name);
        }
      });
    });
    return template.innerHTML;
  };
  try {
    const response = await fetch(`/api/products?slug=${encodeURIComponent(slug)}`, { headers:{Accept:'application/json'} });
    if (!response.ok) return;
    const { product } = await response.json(); if (!product) return;
    const columns = section.querySelectorAll(':scope > .shell > div');
    const mediaColumn=columns[0],copyColumn=columns[1]; if(!mediaColumn||!copyColumn)return;
    const mainImage=mediaColumn.querySelector(':scope > img'),thumbs=mediaColumn.querySelector('.thumbs');
    if(mainImage&&product.image_url){mainImage.src=product.image_url;mainImage.removeAttribute('srcset');mainImage.alt=product.name;}
    const productHero=document.querySelector('.product-page-hero');
    if(productHero){const heroHeading=productHero.querySelector('h1');if(heroHeading)heroHeading.textContent=product.name;productHero.style.setProperty('background-image',"url('/assets/images/hero-selected/shop-product-showcase-1920.webp')",'important');}
    if(thumbs){thumbs.replaceChildren();[product.image_url,...(product.gallery||[]).map(image=>image.url)].filter(Boolean).forEach((url,index)=>{const image=document.createElement('img');image.src=url;image.alt=index?`${product.name} gallery image ${index}`:product.name;image.loading='lazy';image.addEventListener('click',()=>{if(mainImage){mainImage.src=url;mainImage.alt=image.alt;}});thumbs.append(image);});}
    document.title=`${product.name} | Fire & Dine`;
    const category=copyColumn.querySelector('.eyebrow'),heading=copyColumn.querySelector('h1'),price=copyColumn.querySelector('.price'),intro=copyColumn.querySelector(':scope > p');
    if(category)category.textContent=product.category||'Product';if(heading)heading.textContent=product.name;
    if(intro){intro.innerHTML=safeProductHtml(product.short_description||product.description||'');}
    const oldLabel=copyColumn.querySelector(':scope > label'),oldSelect=copyColumn.querySelector(':scope > select');oldLabel?.remove();oldSelect?.remove();
    const sizeGuide=product.size_variation_guide;
    const sizeAttribute=sizeGuide?.attribute||Object.keys(product.attributes||{}).find(attribute=>/size/i.test(attribute));
    const hasSizeVariation=Boolean(sizeAttribute);
    const options=document.createElement('div');options.className='product-options';
    const selections={};
    Object.entries(product.attributes||{}).forEach(([attribute,values])=>{if(sizeGuide&&attribute===sizeAttribute)return;const label=document.createElement('label');label.textContent=attribute;const select=document.createElement('select');select.className='field';select.dataset.attribute=attribute;const placeholder=document.createElement('option');placeholder.value='';placeholder.textContent=`Select ${attribute}`;select.append(placeholder,...(Array.isArray(values)?values:[values]).map(value=>{const option=document.createElement('option');option.value=value;option.textContent=value;return option;}));select.addEventListener('change',()=>{selections[attribute]=select.value;resolveVariation();});label.append(select);options.append(label);});
    const quantity=copyColumn.querySelector('.qty');if(quantity)copyColumn.insertBefore(options,quantity);else copyColumn.append(options);
    const quantityInput=quantity?.querySelector('input');
    const selectedQuantity=()=>Math.max(1,Math.min(99,Number.parseInt(quantityInput?.value||'1',10)||1));
    const productActions=copyColumn.querySelector('.actions');
    const quote=productActions?.querySelector('.btn-gold');
    if(productActions){
      productActions.classList.add('fd-product-detail-actions');
      const addSecondary=(label,href)=>{if([...productActions.querySelectorAll('a')].some(link=>link.textContent.trim().toLowerCase()===label.toLowerCase()))return;const link=document.createElement('a');link.className='btn btn-outline fd-light-gold-outline';link.href=href;link.textContent=label;productActions.append(link);};
      addSecondary('Enquire',`/contact?product=${encodeURIComponent(product.name)}`);
      addSecondary('WhatsApp About This Product',`https://wa.me/27834381485?text=${encodeURIComponent(`Hello Fire & Dine, I would like information about ${product.name}.`)}`);
      addSecondary('Request a Delivery Quote',`/contact?product=${encodeURIComponent(product.name)}&subject=delivery-quote`);
      productActions.querySelectorAll('a:not(.btn-gold)').forEach(link=>{link.classList.remove('fd-dark-gold-outline');link.classList.add('btn','btn-outline','fd-light-gold-outline');});
      productActions.querySelectorAll('a[href^="https://wa.me/"]').forEach(link=>{link.target='_blank';link.rel='noopener noreferrer';});
    }
    copyColumn.querySelectorAll('a').forEach(link => {
      const label = link.textContent.trim();
      if (/whatsapp about this product/i.test(label)) {
        link.href = `https://wa.me/27834381485?text=${encodeURIComponent(`Hello Fire & Dine, I would like information about ${product.name}.`)}`;
      } else if (/request a delivery quote/i.test(label)) {
        link.href = `/contact?product=${encodeURIComponent(product.name)}`;
      }
    });
    const format=value=>value!==null&&value!==''&&Number(value)>0?`R${Number(value).toFixed(2)}`:'Request current pricing';
    const variationPrice=variation=>Number(variation?.sale_price||variation?.regular_price||0);
    let sizeCards=[];
    const matchingSizePrices=sizeValue=>{
      const matching=(product.variations||[]).filter(variation=>{
        const attributes=variation.attributes||{};
        if(attributes[sizeAttribute]!==sizeValue)return false;
        return Object.entries(selections).every(([attribute,value])=>!value||attribute===sizeAttribute||attributes[attribute]===value);
      });
      const pool=matching.length?matching:(product.variations||[]).filter(variation=>(variation.attributes||{})[sizeAttribute]===sizeValue);
      return [...new Set(pool.map(variationPrice).filter(value=>value>0))].sort((a,b)=>a-b);
    };
    const sizeCardPrice=sizeValue=>{const values=matchingSizePrices(sizeValue);if(!values.length)return'Request current pricing';return values.length===1?format(values[0]):`From ${format(values[0])}`;};
    const renderSizeCards=()=>sizeCards.forEach(card=>{const selected=selections[sizeAttribute]===card.dataset.sizeValue;card.classList.toggle('is-selected',selected);card.setAttribute('aria-pressed',selected?'true':'false');const cardPrice=card.querySelector('.fd-size-card-price');if(cardPrice)cardPrice.textContent=sizeCardPrice(card.dataset.sizeValue);});
    if(sizeGuide?.items?.length){
      const guide=document.createElement('section');guide.className='fd-size-variation-guide';guide.setAttribute('aria-labelledby','fd-size-guide-title');
      const heading=document.createElement('div');heading.className='fd-size-guide-heading';heading.innerHTML='<h3 id="fd-size-guide-title">Available Sizes</h3>';
      const grid=document.createElement('div');grid.className='fd-size-variation-grid';grid.style.setProperty('--fd-size-count',String(sizeGuide.items.length));grid.setAttribute('role','group');grid.setAttribute('aria-label',`${product.name} sizes`);
      sizeGuide.items.forEach(item=>{const card=document.createElement('button');card.type='button';card.className='fd-size-variation-card';card.dataset.sizeValue=item.value;card.setAttribute('aria-pressed','false');const cardHead=document.createElement('span');cardHead.className='fd-size-card-head';const title=document.createElement('strong');title.className='fd-size-card-title';title.textContent=item.label;const cardPrice=document.createElement('span');cardPrice.className='fd-size-card-price';cardHead.append(title,cardPrice);const dimensions=document.createElement('span');dimensions.className='fd-size-card-dimensions';[['Front to back','front_to_back'],['Side to side','side_to_side'],['Inner diameter','inner_diameter']].forEach(([label,key])=>{const row=document.createElement('span');row.className='fd-size-card-dimension';const name=document.createElement('span');name.textContent=label;const value=document.createElement('b');value.textContent=item.dimensions?.[key]||'—';row.append(name,value);dimensions.append(row);});card.append(cardHead,dimensions);card.addEventListener('click',()=>{selections[sizeAttribute]=item.value;resolveVariation();});grid.append(card);sizeCards.push(card);});
      guide.append(heading,grid);copyColumn.insertBefore(guide,intro||options);renderSizeCards();
    }
    const sizeLabel=attributes=>sizeAttribute?String((attributes||{})[sizeAttribute]||selections[sizeAttribute]||'').trim():'';
    const displaySizeLabel=label=>/^meastro$/i.test(label)?'Maestro':label;
    const selectedDescription=(label,displayPrice)=>label?`${displaySizeLabel(label)} - ${displayPrice}`:'';
    let selectedOptionDescription='';
    const syncShareLinks=()=>{
      if(!hasSizeVariation)return;
      const message=selectedOptionDescription?`${product.name} - ${selectedOptionDescription}`:product.name;
      copyColumn.querySelectorAll('a[href^="https://wa.me/"]').forEach(link=>{link.href=`https://wa.me/27834381485?text=${encodeURIComponent(`Hello Fire & Dine, I would like information about ${message}.`)}`;});
      copyColumn.querySelectorAll('a[href^="/contact"]').forEach(link=>{const url=new URL(link.getAttribute('href'),location.origin);url.searchParams.set('product',message);link.href=`${url.pathname}${url.search}`;});
    };
    const resolveVariation=()=>{const variations=product.variations||[];const activeSelections=Object.entries(selections).filter(([,value])=>value);const candidates=variations.length?variations.filter(variation=>activeSelections.every(([key,value])=>(variation.attributes||{})[key]===value)):[];let selected=variations.length?variations.find(variation=>Object.entries(variation.attributes||{}).every(([key,value])=>selections[key]===value)):null;if(hasSizeVariation&&selections[sizeAttribute]&&!selected&&candidates.length){const fallback=candidates[0];Object.entries(fallback.attributes||{}).forEach(([key,value])=>{if(selections[key])return;selections[key]=value;const select=[...options.querySelectorAll('select[data-attribute]')].find(field=>field.dataset.attribute===key);if(select)select.value=value;});selected=fallback;}let displayPrice='Request current pricing';if(price){if(selected){displayPrice=format(selected.sale_price||selected.regular_price);price.textContent=displayPrice;}else if(!variations.length){displayPrice=format(product.sale_price||product.regular_price);price.textContent=displayPrice;}else{const values=variations.map(item=>Number(item.sale_price||item.regular_price)).filter(value=>value>0);displayPrice=values.length?(Math.min(...values)===Math.max(...values)?`R${Math.min(...values).toFixed(2)}`:`R${Math.min(...values).toFixed(2)} - R${Math.max(...values).toFixed(2)}`):'Request current pricing';price.textContent=displayPrice;}}renderSizeCards();const summaryLabel=hasSizeVariation?sizeLabel(selected?.attributes):'';selectedOptionDescription=selectedDescription(summaryLabel,displayPrice);if(intro){intro.innerHTML=safeProductHtml(product.short_description||product.description||'');if(selectedOptionDescription){const selectedSummary=document.createElement('p');selectedSummary.className='fd-selected-variation-summary';selectedSummary.textContent=selectedOptionDescription;intro.append(selectedSummary);}}syncShareLinks();if(quote){const ready=!variations.length||!!selected;quote.textContent='Add to Quote';quote.classList.toggle('is-disabled',!ready);quote.setAttribute('aria-disabled',ready?'false':'true');quote.href=ready?'/cart':'#';if(ready){quote.dataset.addToQuote='';quote.dataset.quoteItem=JSON.stringify({product_id:Number(product.id),variation_id:selected?Number(selected.id):null,name:product.name,image_url:product.image_url,attributes:selected?selected.attributes:{},short_description:selectedOptionDescription,share_description:selectedOptionDescription,unit_price:selected?Number(selected.sale_price||selected.regular_price||0):Number(product.sale_price||product.regular_price||0),quantity:selectedQuantity()});}else{delete quote.dataset.addToQuote;delete quote.dataset.quoteItem;}}};
    quantityInput?.addEventListener('input',resolveVariation);
    quantityInput?.addEventListener('change',resolveVariation);
    resolveVariation();
    const firstDetails=copyColumn.querySelector('.tabs details p');if(firstDetails&&product.description)firstDetails.innerHTML=safeProductHtml(product.description);

    const relatedGrid=[...document.querySelectorAll('.product-detail ~ section .products')][0];
    if(relatedGrid){
      try{
        const relatedResponse=await fetch('/api/products?limit=100',{headers:{Accept:'application/json'}});
        if(relatedResponse.ok){
          const relatedPayload=await relatedResponse.json();
          const available=(relatedPayload.products||[]).filter(item=>Number(item.id)!==Number(product.id));
          const sameCategory=available.filter(item=>item.category_slug&&item.category_slug===product.category_slug);
          const related=[...sameCategory,...available.filter(item=>!sameCategory.includes(item))].slice(0,4);
          relatedGrid.replaceChildren(...related.map(buildFdProductCard));
          relatedGrid.closest('section')?.classList.add('fd-related-products');
        }
      }catch(_){/* Keep the server-rendered fallback when catalogue data is unavailable. */}
    }
  } catch (_) { /* Preserve the existing static product page if the API is unavailable. */ }
});

// Quote basket behaviour is loaded once and uses delegated events for API-rendered products.
if(!document.querySelector('script[src="/assets/js/quote-basket.js"]')){const quoteScript=document.createElement('script');quoteScript.src='/assets/js/quote-basket.js';document.head.append(quoteScript);}

// Keep every final CTA aligned with the page intent and the quote-led sales journey.
document.addEventListener('DOMContentLoaded', () => {
  const cta = document.querySelector('.site-final-cta');
  if (!cta) return;
  const path = location.pathname.toLowerCase().replace(/\.(?:html|php)$/,'').replace(/\/$/,'') || '/';
  const groups = {
    consultation: ['/about','/about-us','/contact','/contact-us','/advice','/compare'],
    products: ['/shop','/product','/product-category','/category','/pizza-ovens','/diy-ovens','/residential-pizza-ovens','/mobile-compact-ovens','/outdoor-models'],
    showroom: ['/gallery','/showroom'],
    installation: ['/installation','/installations','/maintenance']
  };
  const type = Object.entries(groups).find(([,paths]) => paths.includes(path))?.[0] || 'quote';
  const content = {
    consultation: {
      image: '01-design-consultation', eyebrow: 'Expert guidance',
      heading: 'Plan the Right Fire & Dine Solution',
      text: 'Share your space, intended use and delivery location. Our team will help you choose the right product and next step.',
      primary: ['Request a Quote','/contact?subject=quote'], secondary: ['Speak to Our Team','https://wa.me/27834381485']
    },
    products: {
      image: '02-shop-pizza-ovens', eyebrow: 'Explore the range',
      heading: 'Find the Right Product for Your Space',
      text: 'Compare Fire & Dine products, then request a tailored quotation with confirmed options, delivery and lead time.',
      primary: ['Request a Quote','/contact?subject=quote'], secondary: ['Compare Products','/compare']
    },
    showroom: {
      image: '03-visit-showroom', eyebrow: 'See the craftsmanship',
      heading: 'Experience Fire & Dine in Person',
      text: 'Explore selected products and discuss your space, finish and intended use with our team.',
      primary: ['Plan Your Visit','/showroom'], secondary: ['Speak to Our Team','https://wa.me/27834381485']
    },
    installation: {
      image: '04-book-installation', eyebrow: 'Installation support',
      heading: 'Plan Your Installation With Confidence',
      text: 'Tell us about your product, site and location so we can advise on preparation, installation and the right next step.',
      primary: ['Request an Installation Quote','/contact?subject=installation'], secondary: ['Get Expert Advice','https://wa.me/27834381485']
    },
    quote: {
      image: '05-request-quote', eyebrow: 'Ready to get started?',
      heading: 'Request a Quote Tailored to Your Project',
      text: 'Tell us what you need and where it needs to go. We will review your requirements and prepare the right quotation.',
      primary: ['Request a Quote','/contact?subject=quote'], secondary: ['View Products','/shop']
    }
  }[type];
  cta.classList.remove('cta-image-01','cta-image-02','cta-image-03','cta-image-04','cta-image-05');
  cta.classList.add(`cta-image-${content.image.slice(0,2)}`);
  cta.style.removeProperty('background-image');
  const eyebrow=cta.querySelector('.eyebrow'),heading=cta.querySelector('h2'),description=cta.querySelector('p'),actions=cta.querySelector('.actions');
  if(eyebrow)eyebrow.textContent=content.eyebrow;
  if(heading)heading.textContent=content.heading;
  if(description)description.textContent=content.text;
  if(actions){
    actions.replaceChildren();
    [content.primary,content.secondary].forEach(([label,href],index)=>{const link=document.createElement('a');link.className=index===1&&(['/','/about','/about-us','/shop','/product','/installation','/installations','/maintenance','/gallery','/showroom','/contact','/contact-us'].includes(path))?'btn btn-outline fd-dark-gold-outline fd-home-cta-button':'btn btn-gold fd-home-cta-button';link.href=href;link.textContent=label;if(href.startsWith('https://wa.me/')){link.target='_blank';link.rel='noopener noreferrer';}actions.append(link);});
  }
});

// Complete the August 2026 website change list without disturbing page-specific content.
document.addEventListener('DOMContentLoaded', () => {
  const path = location.pathname.toLowerCase().replace(/\.(?:html|php)$/,'').replace(/\/$/,'') || '/';

  if (path === '/shop') document.body.classList.add('fd-shop-page');
  document.querySelectorAll('.site-final-cta .eyebrow, .image-cta .eyebrow, .faq-cta .eyebrow, .maintenance-cta .eyebrow').forEach(eyebrow => {
    const label = eyebrow.textContent.trim();
    if (!label) return;
    const makeIcon = () => {
      const icon = document.createElement('img');
      icon.className = 'eyebrow-icon fd-cta-eyebrow-icon';
      icon.src = '/assets/images/icon/fire-eyebrow-icon.svg';
      icon.alt = '';
      icon.setAttribute('aria-hidden', 'true');
      return icon;
    };
    const text = document.createElement('span');
    text.className = 'fd-cta-eyebrow-label';
    text.textContent = label;
    eyebrow.replaceChildren(makeIcon(), text, makeIcon());
    eyebrow.classList.add('fd-cta-eyebrow');
  });

  // Repair visible mojibake introduced by a previous double encoding pass.
  const replacements = new Map([
    ['\u00e2\u20ac\u201d','—'],['\u00c2\u00a9','©'],['\u00c2\u00b7','·'],
    ['\u00e2\u201e\u00a2','™'],['\u00e2\u2020\u2019','→'],['\u00e2\u02c6\u2019','−'],
    ['\u00e2\u20ac\u0153','“'],['\u00e2\u20ac\u009d','”'],['\u00e2\u20ac\u201c','–']
  ]);
  const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);
  while(walker.nextNode()) replacements.forEach((good,bad)=>{if(walker.currentNode.nodeValue.includes(bad))walker.currentNode.nodeValue=walker.currentNode.nodeValue.split(bad).join(good);});
  const stoneskinWalker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT);while(stoneskinWalker.nextNode()){const node=stoneskinWalker.currentNode;if(/StoneSkin\s*™/i.test(node.nodeValue))node.nodeValue=node.nodeValue.replace(/StoneSkin\s*™/gi,'StoneSkin');}
  document.title=document.title.replace(/StoneSkin\s*™/gi,'StoneSkin');

  // Search beside the cart, with live product suggestions and a shop-results fallback.
  const cart=document.querySelector('.header .cart-link');
  if(cart && !document.querySelector('.header-search')){
    const tools=document.createElement('div');tools.className='header-tools';
    const button=document.createElement('button');button.className='header-search';button.type='button';button.setAttribute('aria-label','Search products');button.innerHTML='<i class="fas fa-search" aria-hidden="true"></i>';
    const dialog=document.createElement('dialog');dialog.className='fd-search-dialog';dialog.innerHTML='<button class="fd-search-close" type="button" aria-label="Close search">×</button><form class="fd-search-form" action="/shop" method="get"><label class="sr-only" for="fd-product-search">Search products</label><input id="fd-product-search" name="search" type="search" autocomplete="off" placeholder="Search products by name…"><div class="fd-search-controls"><label>Category<select name="category"><option value="">All categories</option><option value="pizza-ovens">Pizza ovens</option><option value="fireplaces">Fireplaces</option><option value="accessories">Accessories</option></select></label><label>Sort<select name="sort"><option value="featured">Featured</option><option value="price-low">Price: low to high</option><option value="price-high">Price: high to low</option></select></label></div><button class="btn btn-gold" type="submit">View matching products</button><div class="fd-live-results" aria-live="polite"></div></form>';
    cart.replaceWith(tools);tools.append(button,cart);document.body.append(dialog);button.addEventListener('click',()=>{dialog.showModal();dialog.querySelector('input').focus();});dialog.querySelector('.fd-search-close').addEventListener('click',()=>dialog.close());
    let timer;const input=dialog.querySelector('input'),results=dialog.querySelector('.fd-live-results');input.addEventListener('input',()=>{clearTimeout(timer);timer=setTimeout(async()=>{const q=input.value.trim();results.replaceChildren();if(q.length<2)return;try{const response=await fetch(`/api/products?search=${encodeURIComponent(q)}`,{headers:{Accept:'application/json'}});if(!response.ok)return;const data=await response.json();(data.products||data.items||[]).slice(0,6).forEach(product=>{const a=document.createElement('a');a.href=`/product?slug=${encodeURIComponent(product.slug)}`;a.textContent=product.name;results.append(a);});}catch(_){/* Shop submission remains available. */}},180);});
  }

  document.querySelectorAll('.category-section .card').forEach(card=>{const link=card.querySelector('a[href]');if(!link)return;card.tabIndex=0;card.setAttribute('role','link');const go=()=>location.href=link.href;card.addEventListener('click',event=>{if(!event.target.closest('a'))go();});card.addEventListener('keydown',event=>{if(event.key==='Enter')go();});});

  document.querySelectorAll('.product-info').forEach(info=>{const original=info.querySelector(':scope > .btn');if(!original||info.querySelector('.fd-product-actions'))return;const product=original.closest('.product');const detail=product?.querySelector('a[href*="product"]')?.href||original.href;const actions=document.createElement('div');actions.className='fd-product-actions';const view=document.createElement('a');view.className='btn btn-outline';view.href=detail;view.textContent='View Details';original.textContent=original.textContent.replace(/\s*[→›»]+\s*$/,'');original.before(actions);actions.append(view,original);});

  if(path==='/shop'){
    document.querySelectorAll('.shop-filter-sticky').forEach(element=>element.classList.remove('shop-filter-sticky'));
  }

  if(path==='/'){
    const family=[...document.querySelectorAll('.section')].find(s=>/family time since 2013/i.test(s.textContent));
    if(family&&!family.querySelector('.fd-family-layout')){const shell=family.querySelector('.shell');const layout=document.createElement('div');layout.className='fd-family-layout';const image=document.createElement('img');image.src='/assets/images/optimized/about-fire-cooking-1200.webp';image.alt='Fire & Dine wood-fired cooking and gathering';const copy=document.createElement('div');copy.className='fd-family-copy';while(shell.firstChild)copy.append(shell.firstChild);layout.append(image,copy);shell.append(layout);}
    const range=[...document.querySelectorAll('.section')].find(s=>/^\s*the range/i.test(s.textContent));range?.classList.add('fd-range-section');
    const stoneskin=[...document.querySelectorAll('.section')].find(s=>/durable stone finish for outdoor living/i.test(s.textContent));const stoneskinEyebrow=stoneskin?.querySelector('.section-head .eyebrow,.eyebrow');if(stoneskinEyebrow&&!stoneskinEyebrow.querySelector('.stoneskin-eyebrow-icon')){const label=stoneskinEyebrow.textContent.trim().replace(/\s*™/g,'');stoneskinEyebrow.replaceChildren();const icon=document.createElement('img');icon.className='stoneskin-eyebrow-icon';icon.src='/assets/images/icon/fire-eyebrow-icon.svg';icon.alt='';icon.setAttribute('aria-hidden','true');const text=document.createElement('span');text.textContent=label;stoneskinEyebrow.append(icon,text);}
    const note=stoneskin?.querySelector('.brand-note');if(note&&!note.querySelector('img'))note.insertAdjacentHTML('afterbegin','<img src="/assets/images/optimized/gallery-mosaic-outdoor-1200.webp" alt="StoneSkin decorative finish for outdoor spaces" loading="lazy">');
  }

  if(path==='/product'){
    const detail=document.querySelector('.product-detail');
    const actions=detail?.querySelector('.actions');if(actions){const tabs=detail.querySelector('.tabs');if(tabs)actions.after(tabs);}
    const related=[...document.querySelectorAll('.product-detail ~ section')].find(section=>/related products/i.test(section.querySelector('h2')?.textContent||''));
    if(related){related.classList.add('fd-related-products');related.querySelectorAll('.fd-product-actions').forEach(group=>{const buttons=group.querySelectorAll('.btn');buttons[0]?.classList.add('fd-light-gold-outline');if(buttons[1]){buttons[1].classList.remove('btn-outline');buttons[1].classList.add('btn-gold');}});}
  }

  if(path==='/about'||path==='/about-us'){
    const guidance=[...document.querySelectorAll('.section')].find(s=>/product guidance/i.test(s.textContent));const copy=guidance?.querySelector('.content-box');if(copy&&!copy.querySelector('.about-guidance-list')){const list=document.createElement('ul');list.className='about-guidance-list';['Space and installation requirements','Residential or commercial use','Delivery, curing and ongoing care','Suitable products and configurations'].forEach(text=>{const li=document.createElement('li');li.textContent=text;list.append(li);});copy.querySelector('p')?.after(list);}
    const approach=[...document.querySelectorAll('.section')].find(s=>/our approach/i.test(s.textContent));if(approach&&!approach.querySelector('.actions'))approach.querySelector('.shell')?.insertAdjacentHTML('beforeend','<div class="actions" style="justify-content:center"><a class="btn btn-gold" href="/contact">Get Expert Guidance</a></div>');
    const manufacturer=[...document.querySelectorAll('.section')].find(s=>/manufacturer, not reseller/i.test(s.textContent));if(manufacturer&&!manufacturer.querySelector('.actions'))manufacturer.querySelector('.shell')?.insertAdjacentHTML('beforeend','<div class="actions" style="justify-content:center"><a class="btn btn-gold" href="/about#manufacturing">Learn About Our Process</a></div>');
    const where=[...document.querySelectorAll('.section')].find(s=>/where we work/i.test(s.textContent));if(manufacturer&&where&&!document.querySelector('.about-brochure-section')){const brochures=document.createElement('section');brochures.className='section about-brochure-section';brochures.innerHTML='<div class="shell"><div class="section-head"><span class="eyebrow"><img src="/assets/images/icon/fire-eyebrow-icon.svg" alt="" class="eyebrow-icon" aria-hidden="true"><span>Plan your fire</span><img src="/assets/images/icon/fire-eyebrow-icon.svg" alt="" class="eyebrow-icon" aria-hidden="true"></span><h2>Explore Our Product Brochures</h2><p>Compare the product range and choose the right conversation for your project.</p></div><div class="about-brochure-grid"><article class="about-brochure-card about-brochure-card--ovens"><div><span class="eyebrow">PDF brochure</span><h3>Fire &amp; Dine Pizza Ovens</h3><p>Explore residential, commercial and custom wood-fired oven options.</p><a class="btn btn-gold" href="/contact?subject=brochure">Request Oven Brochure</a></div></article><article class="about-brochure-card about-brochure-card--flint"><div><span class="eyebrow">PDF brochure</span><h3>Fire &amp; Dine Flint 1</h3><p>Discover the Flint range and finish options for a considered outdoor space.</p><a class="btn btn-gold" href="/contact?subject=brochure">Request Flint Brochure</a></div></article></div></div>';where.before(brochures);}
    if(where&&!where.querySelector('.about-where-layout')){const shell=where.querySelector('.shell');const content=document.createElement('div');content.className='about-where-layout';const media=document.createElement('img');media.src='/assets/images/optimized/about-fire-cooking-1200.webp';media.alt='Fire & Dine installation and delivery service';const text=document.createElement('div');while(shell.firstChild)text.append(shell.firstChild);content.append(media,text);shell.append(content);where.classList.add('fd-alt-white');}
  }

  if(path==='/contact'){
    document.querySelectorAll('a[href*="/commercial-ovens"]').forEach(link=>{link.href='/contact?subject=commercial';link.dataset.contactPopup='commercial';});
    const confirmed=[...document.querySelectorAll('.section')].find(s=>/confirmed contact details/i.test(s.textContent));const starter=document.querySelector('.contact-get-started');if(confirmed){confirmed.classList.add('contact-confirmed-first');if(starter)starter.replaceWith(confirmed);}
    const mapSection=[...document.querySelectorAll('.section')].find(s=>s.querySelector('.map'));if(mapSection){mapSection.className='contact-map-full';mapSection.innerHTML='<iframe title="Fire & Dine location map" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3562.836226319869!2d27.75035567543386!3d-26.7496018767447!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1e945b3b0e3330d3%3A0x64c08f6d71bf03c1!2sRusticana%20Vanderbijlpark%2C%2031%20Springbok%20Ave%2C%20Rusticana%20AH%2C%20Vanderbijlpark%2C%201911!5e0!3m2!1sen!2sza!4v1786457121156!5m2!1sen!2sza" allowfullscreen loading="lazy" referrerpolicy="strict-origin-when-cross-origin"></iframe>';}
    [...document.querySelectorAll('.section')].filter(s=>/tell us about your project|planning a commercial installation|need installation or maintenance advice/i.test(s.textContent)).forEach(s=>s.remove());
  }

  const bindEnquiryForm = form => {
    if (!form || form.dataset.enquiryBound === 'true') return;
    const status = form.querySelector('.form-status');
    const submit = form.querySelector('[type="submit"]');
    if (!status || !submit) return;
    form.dataset.enquiryBound = 'true';
    const defaultLabel = submit.textContent.trim() || 'Send Enquiry';
    let submitting = false;
    form.addEventListener('submit', async event => {
      event.preventDefault();
      status.className = 'form-status full';
      status.textContent = '';
      if (submitting) return;
      if (form.elements.website?.value) return;
      if (!form.checkValidity()) {
        form.reportValidity();
        status.classList.add('error');
        status.textContent = 'Please complete the required fields before continuing.';
        return;
      }
      submitting = true;
      submit.disabled = true;
      submit.textContent = 'Sending…';
      const data = new FormData(form);
      data.append('attribution', localStorage.getItem('x3_latest_attribution') || '{}');
      try {
        const token = await fetch('/api/enquiries', { headers: { Accept: 'application/json' } }).then(response => response.json());
        const response = await fetch('/api/enquiries', { method: 'POST', body: data, headers: { Accept: 'application/json', 'X-CSRF-Token': token.csrf_token } });
        const result = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(result.error || 'Your enquiry could not be sent. Please try again.');
        form.reset();
        status.classList.add('success');
        status.textContent = `Thank you. Your enquiry was sent successfully. Reference: ${result.reference}`;
        document.dispatchEvent(new CustomEvent('x3:lead-success', { detail: { event_id: result.tracking_event_id, lead_reference: result.reference } }));
      } catch (error) {
        status.classList.add('error');
        status.textContent = error.message || 'Your enquiry could not be sent. Please call or WhatsApp us.';
      } finally {
        submitting = false;
        submit.disabled = false;
        submit.textContent = defaultLabel;
      }
    });
  };

  const contactPaths = new Set(['/contact', '/contact.html']);
  let contactPopup = null;
  let contactPopupTrigger = null;

  const applyContactIntent = (form, url, fallbackProduct = '') => {
    if (!form || !url) return;
    const params = url instanceof URL ? url.searchParams : new URLSearchParams(url);
    const product = params.get('product') || fallbackProduct;
    const subject = params.get('subject') || '';
    const productField = form.querySelector('[name="product"]');
    const messageField = form.querySelector('[name="message"]');
    const subjectMessages = {
      quote: 'I would like to request a quote.',
      brochure: 'I would like to request a product brochure.',
      installation: 'I would like installation support.',
      commercial: 'I would like to discuss a commercial project.',
      'similar-installation': 'I would like to discuss a similar installation.'
    };
    if (product && productField) {
      const match = [...productField.options].find(option => option.textContent.trim().toLowerCase() === product.trim().toLowerCase());
      productField.value = match ? match.value : (/fireplace/i.test(product) ? 'Fireplace' : /installation/i.test(product) ? 'Installation support' : 'Pizza oven');
    }
    const intent = product ? `I would like to enquire about ${product}.` : (subjectMessages[subject] || '');
    if (intent && messageField && !messageField.value.trim()) messageField.value = intent;
  };

  const createContactPopup = () => {
    if (contactPopup) return contactPopup;
    const modal = document.createElement('div');
    modal.className = 'fd-contact-modal';
    modal.hidden = true;
    modal.innerHTML = `<div class="fd-contact-modal__dialog" aria-labelledby="fd-contact-modal-title" aria-modal="true" role="dialog"><button class="fd-contact-modal__close" type="button" aria-label="Close contact form" data-contact-popup-close><i class="fas fa-times" aria-hidden="true"></i></button><div class="fd-contact-modal__content"><aside class="fd-contact-modal__details"><span class="eyebrow">Contact Fire &amp; Dine</span><h2 id="fd-contact-modal-title">Start Your Enquiry</h2><p>Tell us about your project and our team will help you plan the right next step.</p><a href="tel:+27834381485"><i class="fas fa-phone-alt" aria-hidden="true"></i><span><strong>083 438 1485</strong><small>Call or WhatsApp</small></span></a><a href="mailto:Info@fireanddine.co.za"><i class="fas fa-envelope" aria-hidden="true"></i><span><strong>Info@fireanddine.co.za</strong><small>Email our team</small></span></a><a href="https://maps.google.com/?q=31+Springbok+Ave+Vanderbijlpark" target="_blank" rel="noopener noreferrer"><i class="fas fa-map-marker-alt" aria-hidden="true"></i><span><strong>Vanderbijlpark, Gauteng</strong><small>Workshop &amp; showroom</small></span></a></aside><div class="fd-contact-modal__form-wrap"><h3>Send an Enquiry</h3><form class="form-grid fd-contact-popup-form" novalidate><label>First Name<input autocomplete="given-name" class="form-control" name="firstName" required></label><label>Last Name<input autocomplete="family-name" class="form-control" name="lastName" required></label><label class="full">Email Address<input autocomplete="email" class="form-control" name="email" required type="email"></label><label class="full">Phone Number<input autocomplete="tel" class="form-control" name="phone" required type="tel"></label><label>Residential or Commercial<select class="form-control" name="application" required><option value="">Select one</option><option>Residential</option><option>Commercial</option></select></label><label>Product or Service<select class="form-control" name="product" required><option value="">Select one</option><option>Pizza oven</option><option>Commercial pizza oven</option><option>Fireplace</option><option>Accessories</option><option>Installation support</option><option>Maintenance support</option><option>General enquiry</option></select></label><label class="full">Province or Delivery Location<input autocomplete="address-level1" class="form-control" name="location" required></label><label class="full">Message<textarea class="form-control" name="message" required rows="5"></textarea></label><label class="full fd-contact-popup-preference">Preferred Contact Method<select class="form-control" name="preferredContact"><option>Email</option><option>Phone</option><option>WhatsApp</option></select></label><label class="honeypot" aria-hidden="true">Leave this field empty<input autocomplete="off" name="website" tabindex="-1"></label><button class="btn btn-gold full" type="submit">Send Enquiry</button><div class="form-status full" aria-live="polite" role="status"></div></form></div></div></div>`;
    document.body.append(modal);
    contactPopup = modal;

    const close = () => {
      modal.hidden = true;
      document.body.classList.remove('fd-contact-modal-open');
      contactPopupTrigger?.focus();
      contactPopupTrigger = null;
    };
    modal.addEventListener('click', event => {
      if (event.target === modal || event.target.closest('[data-contact-popup-close]')) close();
    });
    document.addEventListener('keydown', event => {
      if (event.key === 'Escape' && !modal.hidden) close();
    });

    const form = modal.querySelector('.fd-contact-popup-form');
    bindEnquiryForm(form);
    return modal;
  };

  const openContactPopup = (trigger, url) => {
    const modal = createContactPopup();
    contactPopupTrigger = trigger;
    const productName = trigger.closest('.product')?.querySelector('h3')?.textContent.trim() || '';
    applyContactIntent(modal.querySelector('form'), url || new URL(trigger.href, location.origin), productName);
    modal.hidden = false;
    document.body.classList.add('fd-contact-modal-open');
    requestAnimationFrame(() => modal.querySelector('[name="firstName"]')?.focus());
  };

  document.addEventListener('click', event => {
    const link = event.target.closest('a[href]');
    if (!link || link.closest('.nav, footer, .footer')) return;
    const url = new URL(link.href, location.origin);
    if (!contactPaths.has(url.pathname)) return;
    event.preventDefault();
    openContactPopup(link, url);
  });
  document.querySelectorAll('form[data-static-contact]').forEach(form => {
    bindEnquiryForm(form);
    applyContactIntent(form, new URL(location.href));
  });
});


// Apply an accessible, consistent dark/light rhythm to every page.
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('main').forEach(main => {
    [...main.children].filter(el => el.tagName === 'SECTION').forEach((section, index) => {
      section.classList.remove('theme-dark', 'theme-light');
      section.classList.add(index % 2 === 0 ? 'theme-dark' : 'theme-light');
    });
  });
  document.querySelectorAll('details > summary').forEach(summary => {
    summary.setAttribute('role', 'button');
    summary.setAttribute('aria-label', summary.textContent.trim());
  });
  document.querySelectorAll('img:not([loading])').forEach(img => {
    if (!img.closest('.hero,.page-hero')) img.loading = 'lazy';
  });

  const fireVisualPattern = /(pizza|oven|wood-fired|fireplace|hearth|flame|ember|fire cooking)/i;
  document.querySelectorAll('img[alt]').forEach(image => {
    if (image.closest('header,footer,.footer,.logo,.footer-logo')) return;
    if (!fireVisualPattern.test(`${image.alt} ${image.getAttribute('src') || ''}`)) return;
    const visual = image.parentElement;
    if (visual && !visual.classList.contains('fd-live-fire')) visual.classList.add('fd-live-fire');
  });
  document.querySelectorAll('.service-visual[aria-label*="oven" i],.service-visual[aria-label*="fireplace" i],.site-final-cta,.image-cta').forEach(visual => {
    visual.classList.add('fd-live-fire');
    visual.dataset.fdFireBackground = '';
  });

  const finePointer = matchMedia('(hover:hover) and (pointer:fine)');
  const reducedMotion = matchMedia('(prefers-reduced-motion:reduce)');
  if (finePointer.matches && !reducedMotion.matches && !document.documentElement.classList.contains('fd-ember-cursor')) {
    document.documentElement.classList.add('fd-ember-cursor');
    const core = document.createElement('span');
    const ring = document.createElement('span');
    core.className = 'fd-ember-cursor-core';
    ring.className = 'fd-ember-cursor-ring';
    document.body.append(core, ring);
    let targetX = -100;
    let targetY = -100;
    let ringX = -100;
    let ringY = -100;
    let raf = 0;
    const render = () => {
      ringX += (targetX - ringX) * .18;
      ringY += (targetY - ringY) * .18;
      core.style.transform = `translate3d(${targetX - 3}px,${targetY - 3}px,0)`;
      ring.style.transform = `translate3d(${ringX - ring.offsetWidth / 2}px,${ringY - ring.offsetHeight / 2}px,0)`;
      if (Math.abs(targetX - ringX) > .12 || Math.abs(targetY - ringY) > .12) raf = requestAnimationFrame(render);
      else raf = 0;
    };
    document.addEventListener('pointermove', event => {
      if (event.pointerType !== 'mouse') return;
      targetX = event.clientX;
      targetY = event.clientY;
      core.classList.add('is-visible');
      ring.classList.add('is-visible');
      if (!raf) raf = requestAnimationFrame(render);
    }, { passive: true });
    document.addEventListener('pointerover', event => {
      ring.classList.toggle('is-active', Boolean(event.target.closest('a,button,input,select,textarea,summary,.card,.product,.product-card,.service-visual')));
    });
    document.addEventListener('pointerdown', () => {
      ring.classList.add('is-pressed');
      setTimeout(() => ring.classList.remove('is-pressed'), 130);
    });
    document.addEventListener('pointerleave', event => {
      if (event.target === document.documentElement) {
        core.classList.remove('is-visible');
        ring.classList.remove('is-visible');
      }
    });
  }

  if (!reducedMotion.matches && 'IntersectionObserver' in window) {
    const revealSelector = 'main .breadcrumbs,main .section-head,main .split-media,main .split-copy,main .content-box,main .card,main .product,main .quote,main .service-showcase,main .about-where-layout,main .fd-family-layout,main .installation-facts-grid,main .fact-grid>article,main .knowledge-grid>article,main .actions';
    const revealItems = [...new Set([...document.querySelectorAll(revealSelector)])].filter(element => !element.closest('.fd-contact-modal'));
    revealItems.forEach((element, index) => {
      element.classList.add('fd-reveal');
      const group = element.parentElement;
      const siblings = group ? [...group.children].filter(sibling => sibling.matches?.('.card,.product,.quote,article,li')) : [];
      const stagger = siblings.indexOf(element);
      element.style.setProperty('--fd-reveal-delay', `${stagger >= 0 ? (stagger % 4) * 70 : index % 2 * 40}ms`);
    });
    document.documentElement.classList.add('fd-motion-ready');
    const revealObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      });
    }, { threshold: .12, rootMargin: '0px 0px -4% 0px' });
    revealItems.forEach(element => revealObserver.observe(element));
  }
});


/* Consolidated shared shop-interaction enhancement. Previously served through the legacy PHP JavaScript bundle. */
document.addEventListener('DOMContentLoaded', () => {
  const path = location.pathname.toLowerCase().replace(/\.(?:html|php)$/,'').replace(/\/$/,'') || '/';

  if (path !== '/shop') return;

  const hero = document.querySelector('.shop-hero');
  if (!hero) return;

  hero.querySelectorAll(':scope > .page-hero-media').forEach(media => media.remove());
  hero.classList.remove('image-page-hero');

  const heroShell = hero.querySelector(':scope > .shell');
  if (!heroShell) return;

  let breadcrumbs = heroShell.querySelector('.breadcrumbs');
  if (!breadcrumbs) {
    breadcrumbs = document.createElement('nav');
    breadcrumbs.className = 'breadcrumbs';
    breadcrumbs.setAttribute('aria-label', 'Breadcrumb');
    breadcrumbs.innerHTML = '<a href="/">Home</a><span aria-hidden="true">›</span><span aria-current="page">Shop</span>';
    heroShell.insertBefore(breadcrumbs, heroShell.firstChild);
  }

  breadcrumbs.style.display = 'flex';
  breadcrumbs.style.flexDirection = 'row';
  breadcrumbs.style.flexWrap = 'nowrap';
  breadcrumbs.style.alignItems = 'center';
  breadcrumbs.style.justifyContent = 'center';
  breadcrumbs.style.gap = '8px';
  breadcrumbs.style.width = 'auto';
  breadcrumbs.style.maxWidth = '100%';
  breadcrumbs.style.margin = '0 0 28px';
  breadcrumbs.style.fontSize = '13px';
  breadcrumbs.style.fontWeight = '500';
  breadcrumbs.style.lineHeight = '1';
  breadcrumbs.style.color = '#fff';

  const homeCrumb = breadcrumbs.querySelector('a[href="/"]');
  if (homeCrumb) homeCrumb.style.color = 'var(--gold2)';

  const breadcrumbParts = breadcrumbs.querySelectorAll('span');
  if (breadcrumbParts[0]) breadcrumbParts[0].style.color = 'var(--gold2)';
  if (breadcrumbParts[1]) breadcrumbParts[1].style.color = '#fff';
});


/* Consolidated page enhancements. Previously served through the legacy PHP JavaScript bundle. */
document.addEventListener('DOMContentLoaded', () => {
  const path = location.pathname.toLowerCase().replace(/\.(?:html|php)$/,'').replace(/\/$/,'') || '/';
  const main = document.querySelector('main');

  const groupBrochures = () => {
    if (!main) return;
    const existingGrid = main.querySelector(':scope > .fd-brochure-grid');
    const looseSections = [...main.querySelectorAll(':scope > .brochure-download')];
    if (!looseSections.length) return;

    const grid = existingGrid || document.createElement('div');
    if (!existingGrid) {
      grid.className = 'fd-brochure-grid';
      looseSections[0].before(grid);
    }
    looseSections.forEach(section => {
      section.classList.add('fd-brochure-item');
      grid.append(section);
    });
  };

  const breadcrumbLabelMap = {
    '/about': 'About Us',
    '/shop': 'Shop',
    '/installation': 'Installation',
    '/gallery': 'Gallery',
    '/contact': 'Contact Us',
    '/compare': 'Compare Products',
    '/faq': 'Frequently Asked Questions',
    '/privacy-policy': 'Privacy Policy',
    '/terms': 'Terms of Service',
    '/showroom': 'Show Room',
    '/pizza-ovens': 'Pizza Ovens',
    '/commercial-ovens': 'Commercial Ovens',
    '/fireplaces': 'Fireplaces',
    '/accessories': 'Accessories',
    '/residential-pizza-ovens': 'Residential Pizza Ovens',
    '/outdoor-models': 'Outdoor Models',
    '/mobile-compact-ovens': 'Mobile & Compact Ovens',
    '/diy-ovens': 'DIY Pizza Ovens',
    '/advice': 'Advice Centre',
    '/stoneskin': 'StoneSkin'
  };

  const normalizeHeroBreadcrumb = (hero, preferredLabel = '') => {
    if (!hero) return;

    const existingBreadcrumbs = [...hero.querySelectorAll('.breadcrumbs')];
    const existingCurrent = existingBreadcrumbs
      .map(item => item.querySelector('[aria-current="page"]')?.textContent?.trim())
      .find(Boolean) || '';
    const activeNavLabel = document.querySelector('.nav a[aria-current="page"], .nav a.active')?.textContent?.trim() || '';
    const currentLabel = preferredLabel || existingCurrent || activeNavLabel;
    if (!currentLabel) return;

    let breadcrumb = hero.querySelector(':scope > .breadcrumbs');
    if (!breadcrumb) {
      breadcrumb = document.createElement('nav');
      breadcrumb.setAttribute('aria-label', 'Breadcrumb');
      hero.prepend(breadcrumb);
    }

    existingBreadcrumbs.forEach(item => {
      if (item !== breadcrumb) item.remove();
    });

    breadcrumb.className = 'breadcrumbs fd-site-breadcrumb';
    breadcrumb.innerHTML = `<a href="/">Home</a><span aria-hidden="true">&#8250;</span><span aria-current="page">${currentLabel}</span>`;

    const important = (element, property, value) => element.style.setProperty(property, value, 'important');
    important(breadcrumb, 'display', 'flex');
    important(breadcrumb, 'flex-direction', 'row');
    important(breadcrumb, 'flex-wrap', 'nowrap');
    important(breadcrumb, 'align-items', 'center');
    important(breadcrumb, 'justify-content', 'center');
    important(breadcrumb, 'gap', '8px');
    important(breadcrumb, 'width', 'fit-content');
    important(breadcrumb, 'max-width', 'calc(100% - 32px)');
    important(breadcrumb, 'min-height', '20px');
    important(breadcrumb, 'margin-left', 'auto');
    important(breadcrumb, 'margin-right', 'auto');
    important(breadcrumb, 'margin-bottom', '28px');
    important(breadcrumb, 'padding', '0');
    important(breadcrumb, 'position', 'relative');
    important(breadcrumb, 'top', 'auto');
    important(breadcrumb, 'left', 'auto');
    important(breadcrumb, 'right', 'auto');
    important(breadcrumb, 'z-index', '5');
    important(breadcrumb, 'font-size', '12px');
    important(breadcrumb, 'font-weight', '500');
    important(breadcrumb, 'line-height', '1.2');
    important(breadcrumb, 'letter-spacing', '0');
    important(breadcrumb, 'text-align', 'center');
    important(breadcrumb, 'transform', 'none');

    const home = breadcrumb.querySelector('a[href="/"]');
    const separator = breadcrumb.querySelector('span[aria-hidden="true"]');
    const current = breadcrumb.querySelector('[aria-current="page"]');

    [home, separator, current].forEach(item => {
      if (!item) return;
      important(item, 'display', 'inline-flex');
      important(item, 'align-items', 'center');
      important(item, 'margin', '0');
      important(item, 'padding', '0');
      important(item, 'white-space', 'nowrap');
      important(item, 'line-height', '1.2');
    });

    if (home) important(home, 'color', '#fcbc4d');
    if (separator) important(separator, 'color', '#ffffff');
    if (current) important(current, 'color', '#ffffff');
  };

  document.getElementById('fd-installation-match-breadcrumb-style')?.remove();

  if (path !== '/') {
    normalizeHeroBreadcrumb(document.querySelector('.page-hero'), breadcrumbLabelMap[path] || '');
  }

  if (main && 'MutationObserver' in window) {
    new MutationObserver(groupBrochures).observe(main, { childList: true });
  }
  groupBrochures();

  if (path === '/about') {
    const hero = document.querySelector('.about-hero');
    if (hero) {
      hero.querySelectorAll(':scope > .page-hero-media').forEach(media => media.remove());
      hero.classList.remove('image-page-hero');
      hero.classList.add('fd-about-hero-fixed');
      normalizeHeroBreadcrumb(hero, 'About Us');
    }

    document.querySelector('.about-hero + .section .actions a[href="/contact"]')
      ?.classList.add('fd-light-gold-outline');

    const anchor = document.querySelector('.site-final-cta');
    if (anchor && !document.querySelector('[data-fd-about-brochures]')) {
      const marker = document.createElement('span');
      marker.hidden = true;
      marker.dataset.fdAboutBrochures = '1';
      anchor.before(marker);
      fetch('/api/brochure.php?location=about', { credentials: 'same-origin' })
        .then(response => response.ok ? response.text() : '')
        .then(html => {
          if (!html.trim()) return;
          const template = document.createElement('template');
          template.innerHTML = html.trim();
          marker.before(template.content);
          groupBrochures();
        })
        .catch(() => {});
    }
  }

  if (path === '/shop') {
    document.body.classList.add('fd-shop-page');
    normalizeHeroBreadcrumb(document.querySelector('.shop-hero'), 'Shop');

    const offering = [...document.querySelectorAll('main .section')].find(section => /more than ovens/i.test(section.querySelector('.section-head .eyebrow')?.textContent || ''));
    if (offering) {
      offering.classList.add('fd-shop-more-range');
      offering.querySelectorAll('a').forEach(link => { if (link.textContent.trim().toLowerCase() === 'explore') link.remove(); });
    }

    document.querySelectorAll('.shop-filter-sticky').forEach(element => element.classList.remove('shop-filter-sticky'));
    const toolbar = document.querySelector('.toolbar');

    const enhanceProductCards = root => {
      root.querySelectorAll('.product-info').forEach(info => {
        if (info.querySelector(':scope > .fd-product-actions')) return;
        const primary = info.querySelector(':scope > .btn');
        if (!primary) return;
        const product = info.closest('.product');
        const mediaLink = product?.querySelector('a[href*="/product"]');
        const detailHref = mediaLink?.getAttribute('href') || primary.getAttribute('href') || '/shop';
        const actions = document.createElement('div');
        actions.className = 'fd-product-actions';
        const view = document.createElement('a');
        view.className = 'btn btn-outline';
        view.href = detailHref;
        view.textContent = 'View Details';
        primary.before(actions);
        actions.append(view, primary);
      });
    };

    enhanceProductCards(document);
    const products = document.querySelector('.products');
    if (products && 'MutationObserver' in window) {
      new MutationObserver(() => enhanceProductCards(products)).observe(products, { childList: true, subtree: true });
    }
  }

});


/* Consolidated optional fine-pointer enhancement. Previously served through the legacy PHP JavaScript bundle. */
document.addEventListener('DOMContentLoaded', () => {
  const finePointer = window.matchMedia('(hover:hover) and (pointer:fine)');
  if (!finePointer.matches) return;

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const root = document.documentElement;
  const cursor = document.createElement('div');
  cursor.className = 'fd-flame-cursor';
  cursor.setAttribute('aria-hidden', 'true');
  cursor.innerHTML = '<span class="fd-flame-cursor__outer"></span><span class="fd-flame-cursor__inner"></span>';
  document.body.appendChild(cursor);
  root.classList.add('fd-flame-cursor-active');

  let x = -100;
  let y = -100;
  let tx = -100;
  let ty = -100;
  let visible = false;
  let raf = 0;

  const render = () => {
    if (reducedMotion) {
      x = tx;
      y = ty;
    } else {
      x += (tx - x) * 0.34;
      y += (ty - y) * 0.34;
    }
    cursor.style.transform = `translate3d(${x}px,${y}px,0) translate(-50%,-88%)`;
    cursor.style.opacity = visible ? '1' : '0';
    raf = requestAnimationFrame(render);
  };

  const move = event => {
    tx = event.clientX;
    ty = event.clientY;
    visible = true;
  };

  const hide = () => { visible = false; };
  const show = () => { visible = true; };

  document.addEventListener('mousemove', move, { passive: true });
  document.addEventListener('mouseenter', show, { passive: true });
  document.addEventListener('mouseleave', hide, { passive: true });
  window.addEventListener('blur', hide, { passive: true });
  window.addEventListener('focus', show, { passive: true });

  raf = requestAnimationFrame(render);

  window.addEventListener('pagehide', () => {
    cancelAnimationFrame(raf);
    root.classList.remove('fd-flame-cursor-active');
  }, { once: true });
});
