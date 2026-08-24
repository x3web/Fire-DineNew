(() => {
  'use strict';

  const path = location.pathname.toLowerCase().replace(/\.(?:html|php)$/i, '').replace(/\/$/, '') || '/';
  const params = new URLSearchParams(location.search);

  const isProductContext = () => (
    path === '/product' ||
    path.startsWith('/product/') ||
    !!document.querySelector('.product-detail, .product-page-hero')
  );

  const applyProductContrast = () => {
    if (!isProductContext() || document.getElementById('fd-product-contrast-fix')) return;
    const style = document.createElement('style');
    style.id = 'fd-product-contrast-fix';
    style.textContent = `
      html body .product-detail .tabs,
      html body .product-detail .tabs details,
      html body .product-detail .tabs summary,
      html body .product-detail .tabs details p,
      html body .product-detail .tabs details li,
      html body .product-detail .tabs details span,
      html body .product-detail .tabs details strong {
        color:#111!important;
        -webkit-text-fill-color:#111!important;
        opacity:1!important;
        text-shadow:none!important;
      }
      html body .product-detail .tabs details > summary,
      html body .product-detail .tabs details > p {
        padding-left:20px!important;
      }
      html body .product-detail .tabs summary::after,
      html body .product-detail .tabs summary::marker {
        color:#fcbc4d!important;
        -webkit-text-fill-color:#fcbc4d!important;
      }
    `;
    document.head.append(style);
  };

  const currentProduct = () => {
    const detail = document.querySelector('.product-detail');
    const mainImage = detail?.querySelector('.shell > div:first-child > img, .two-col > div:first-child > img');
    const name = params.get('name') || detail?.querySelector('h1')?.textContent?.trim() || '';
    const image = params.get('image') || mainImage?.currentSrc || mainImage?.getAttribute('src') || '';
    return { name, image };
  };

  const applyHero = () => {
    if (!isProductContext()) return false;

    const hero = document.querySelector('.product-page-hero');
    const product = currentProduct();
    if (!hero || !product.name) return false;

    const heading = hero.querySelector('h1');
    if (heading) heading.textContent = product.name;
    hero.style.setProperty('background-image', "url('/assets/images/hero-selected/shop-product-showcase-1920.webp')", 'important');
    hero.style.setProperty('background-size', 'cover', 'important');
    hero.style.setProperty('background-position', 'center center', 'important');
    hero.style.setProperty('background-repeat', 'no-repeat', 'important');
    hero.style.setProperty('background-color', '#111', 'important');
    hero.classList.add('fd-single-overlay');
    hero.dataset.productHeroImage = 'shop-product-showcase';
    return true;
  };

  const scheduleHero = () => {
    applyProductContrast();
    applyHero();
    requestAnimationFrame(applyHero);
    [50, 150, 350, 750, 1500, 3000].forEach(delay => setTimeout(applyHero, delay));
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', scheduleHero, { once: true });
  } else {
    scheduleHero();
  }

  window.addEventListener('load', scheduleHero, { once: true });

  const observer = new MutationObserver(() => {
    if (!isProductContext()) return;
    applyProductContrast();
    const hero = document.querySelector('.product-page-hero');
    const product = currentProduct();
    if (!hero || !product.name) return;
    if (!hero.style.getPropertyValue('background-image').includes('shop-product-showcase')) {
      requestAnimationFrame(applyHero);
    }
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['style']
  });

  setTimeout(() => {
    applyProductContrast();
    applyHero();
    observer.disconnect();
  }, 10000);
})();
(() => {
  'use strict';
  if (!/^\/product(?:\.html)?\/?$/i.test(location.pathname)) return;

  const css = `
    .product-detail .product-description{box-sizing:border-box;width:100%;max-width:900px;margin:18px 0 22px;padding:0 20px;line-height:1.7;overflow-wrap:anywhere}
    .product-detail .product-description>*:first-child{margin-top:0!important}.product-detail .product-description>*:last-child{margin-bottom:0!important}
    .product-detail .product-description p{margin:0 0 16px!important;line-height:1.7!important}
    .product-detail .product-description h3{margin:26px 0 10px!important;font-size:clamp(1.05rem,1.45vw,1.25rem)!important;line-height:1.3!important;color:var(--gold2,#fcbc4d)!important;-webkit-text-fill-color:var(--gold2,#fcbc4d)!important}
    .product-detail .product-description .fd-size-guide-heading{margin:18px 0 8px!important;font-family:"Inter",Arial,sans-serif!important;font-size:18px!important;font-weight:500!important;font-style:normal!important;line-height:1.3!important;letter-spacing:.06em!important;text-transform:none!important;color:inherit!important;-webkit-text-fill-color:currentColor!important}
    .product-detail .product-description ul{margin:0 0 18px!important;padding-left:24px!important}.product-detail .product-description li{margin:0 0 7px!important;line-height:1.65!important}
    .product-detail .product-description a{color:var(--gold2,#fcbc4d)!important;-webkit-text-fill-color:var(--gold2,#fcbc4d)!important;text-decoration:underline;text-underline-offset:2px}
    .product-detail .product-description .fd-desc-group{margin:0 0 14px}.product-detail .product-description .fd-desc-group strong{display:block;margin-bottom:4px}
    .product-detail .tabs .product-description{margin:8px 0 16px!important;padding:0 20px!important;color:#111!important;-webkit-text-fill-color:#111!important}
    .product-detail .tabs .product-description :is(p,li,strong,h4,div){color:#111!important;-webkit-text-fill-color:#111!important}.product-detail .tabs .product-description h3{color:#111!important;-webkit-text-fill-color:#111!important;padding-left:10px;border-left:3px solid var(--gold2,#fcbc4d)}
    .product-detail .tabs .product-description a{color:#111!important;-webkit-text-fill-color:#111!important}
    @media(max-width:680px){.product-detail .product-description,.product-detail .tabs .product-description{padding-left:16px!important;padding-right:16px!important}.product-detail .product-description ul{padding-left:20px!important}}
  `;
  if (!document.getElementById('fd-product-description-styles')) {
    const style=document.createElement('style');style.id='fd-product-description-styles';style.textContent=css;document.head.append(style);
  }

  const sectionNames = /^(sizes?|dimensions?|specifications?|oven specifications|extra options?|optional extras?|features?|finish options?|customisation|customization|contact|shipping(?:\s*&\s*delivery)?|delivery|installation|care\s*&\s*maintenance|need help or customisation\??|garden route orders?)\s*:?\s*$/i;
  const labelPattern = /(Coastal Upgrade|Built[- ]?in Thermometer|Choose Your Finish|Mosaic|Front to back|Side to side|Inner Diameter|Shipping|Delivery|Email|Phone|For Garden Route orders)\s*:\s*/gi;
  const normalize = value => {
    let text=String(value||'');
    for(let i=0;i<2;i++) text=text.replace(/\\r\\n|\\n|\\r/g,'\n');
    return text.replace(/\r\n?/g,'\n').replace(/\u00a0/g,' ');
  };

  const extractText = root => {
    let out='';
    const walk=node=>{
      if(node.nodeType===Node.TEXT_NODE){out+=normalize(node.nodeValue);return;}
      if(node.nodeType!==Node.ELEMENT_NODE)return;
      const tag=node.tagName.toUpperCase();
      if(tag==='BR'){out+='\n';return;}
      const block=/^(P|DIV|BLOCKQUOTE|H[2-6]|UL|OL|TABLE)$/.test(tag);
      if(block) out+='\n\n';
      if(tag==='LI') out+='\n• ';
      [...node.childNodes].forEach(walk);
      if(tag==='LI') out+='\n';
      if(block) out+='\n\n';
    };
    [...root.childNodes].forEach(walk);
    return normalize(out).replace(/[ \t]+\n/g,'\n').replace(/\n[ \t]+/g,'\n').replace(/\n{3,}/g,'\n\n').trim();
  };

  const safeHref = href => /^(?:https?:\/\/|mailto:|tel:|\/|#)/i.test(href||'') ? href : '';
  const collectLinks = root => [...root.querySelectorAll('a[href]')].map(a=>({text:(a.textContent||'').trim(),href:safeHref(a.getAttribute('href'))})).filter(link=>link.text&&link.href);
  const linkify = (element,text,links) => {
    const generic=/(https?:\/\/[^\s<]+|[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}|\+27\s?(?:\d[\s-]?){8,10})/gi;
    let pos=0;
    while(pos<text.length){
      generic.lastIndex=pos;const gm=generic.exec(text);
      let best=gm?{index:gm.index,text:gm[0],href:gm[0].includes('@')?'mailto:'+gm[0]:gm[0].startsWith('+27')?'tel:'+gm[0].replace(/\s|-/g,''):gm[0]}:null;
      links.forEach(link=>{const index=text.indexOf(link.text,pos);if(index>=0&&(!best||index<best.index))best={index,text:link.text,href:link.href};});
      if(!best){element.append(document.createTextNode(text.slice(pos)));break;}
      if(best.index>pos)element.append(document.createTextNode(text.slice(pos,best.index)));
      const a=document.createElement('a');a.textContent=best.text;a.href=best.href;element.append(a);pos=best.index+best.text.length;
    }
  };

  const heading=(box,text)=>{const h=document.createElement('h3');h.textContent=text;box.append(h)};
  const appendParagraph=(box,text,links)=>{if(!text)return;const p=document.createElement('p');linkify(p,text,links);box.append(p)};
  const appendList=(box,items,links)=>{const ul=document.createElement('ul');items.forEach(text=>{const li=document.createElement('li');linkify(li,text,links);ul.append(li)});box.append(ul)};
  const appendGroup=(box,label,body,links)=>{const wrap=document.createElement('div');wrap.className='fd-desc-group';const strong=document.createElement('strong');strong.textContent=label;wrap.append(strong);if(body){const div=document.createElement('div');linkify(div,body,links);wrap.append(div)}box.append(wrap)};
  const titleCase = value => value.replace(/\b\w/g,c=>c.toUpperCase()).replace(/Built[- ]?In/i,'Built-in').replace(/Front To Back/i,'Front to back').replace(/Side To Side/i,'Side to side').replace(/Inner Diameter/i,'Inner diameter');

  const splitGroups = text => {
    labelPattern.lastIndex=0;const matches=[...text.matchAll(labelPattern)];if(matches.length<2)return null;
    return {prelude:text.slice(0,matches[0].index).trim(),groups:matches.map((match,index)=>({label:match[1],body:text.slice(match.index+match[0].length,index+1<matches.length?matches[index+1].index:text.length).trim()}))};
  };

  const format = source => {
    if(!source||source.dataset.fdDescriptionFormatted==='1')return;
    const raw=extractText(source);if(!raw)return;const links=collectLinks(source);
    const box=document.createElement('div');box.className='product-description';box.dataset.fdDescriptionFormatted='1';if(source.id)box.id=source.id;
    const chunks=raw.split(/\n{2,}/).map(v=>v.trim()).filter(Boolean);
    chunks.forEach((chunk,index)=>{
      const lines=chunk.split(/\n+/).map(v=>v.trim()).filter(Boolean);if(!lines.length)return;
      if(lines.length===1&&sectionNames.test(lines[0])){heading(box,lines[0].replace(/\s*:\s*$/,''));return;}
      if(lines.every(line=>/^[•✔✓]\s*/.test(line))){appendList(box,lines.map(line=>line.replace(/^[•✔✓]\s*/,'')),links);return;}
      if(lines.length===1){
        let text=lines[0];
        if(/^📧?\s*For Garden Route orders\b/i.test(text)){heading(box,'Garden Route Orders');text=text.replace(/^📧?\s*For Garden Route orders\s*:?\s*/i,'');}
        const multi=splitGroups(text);
        if(multi){
          if(/\b(?:Email|Phone)\s*:/i.test(text)&&!/\b(?:Shipping|Delivery)\s*:/i.test(text)&&!/Garden Route/i.test(chunk))heading(box,'Need Help or Customisation?');
          if(/\b(?:Shipping|Delivery)\s*:/i.test(text))heading(box,'Shipping & Delivery');
          if(multi.prelude)appendParagraph(box,multi.prelude,links);
          multi.groups.forEach(group=>appendGroup(box,titleCase(group.label),group.body,links));return;
        }
        const one=text.match(/^([^:]{2,45}):\s*(.+)$/);if(one){
          const vals=[...one[2].matchAll(/([^()]+?)\s*\(([^)]+)\)/g)];if(vals.length>=2){const h=document.createElement('h4');h.className='fd-size-guide-heading';h.textContent=one[1];box.append(h);appendList(box,vals.map(v=>v[1].trim()+' — '+v[2].trim()),links);return;}
          if(/^(shipping|delivery)$/i.test(one[1])){heading(box,'Shipping & Delivery');appendGroup(box,titleCase(one[1]),one[2],links);return;}
          if(/^(email|phone)$/i.test(one[1])){heading(box,'Need Help or Customisation?');appendGroup(box,titleCase(one[1]),one[2],links);return;}
        }
        const bullet=text.split(/[•✔✓]/).map(v=>v.trim()).filter(Boolean);if(bullet.length>1){appendList(box,bullet,links);return;}
        const firstTitle=index===0&&text.length<=90&&!/[.!?]$/.test(text)&&text.split(/\s+/).length<=12;if(firstTitle){heading(box,text);return;}
      }
      lines.forEach(line=>{if(sectionNames.test(line))heading(box,line.replace(/\s*:\s*$/,''));else if(/^[•✔✓]\s*/.test(line))appendList(box,[line.replace(/^[•✔✓]\s*/,'')],links);else appendParagraph(box,line,links)});
    });
    source.replaceWith(box);
  };

  const bindQuantityControl = detail => {
    const quantity = detail?.querySelector('.qty');
    const input = quantity?.querySelector('input');
    if (!quantity || !input || quantity.dataset.quantityBound === 'true') return;
    quantity.dataset.quantityBound = 'true';
    input.type = 'number';
    input.min = '1';
    input.max = '99';
    input.inputMode = 'numeric';
    const clamp = value => Math.max(1, Math.min(99, Number.parseInt(value, 10) || 1));
    const set = value => { input.value = String(clamp(value)); input.dispatchEvent(new Event('change', { bubbles: true })); };
    let buttons = [...quantity.querySelectorAll(':scope > button')];
    if (buttons.length < 2) {
      const decrease = document.createElement('button');
      decrease.type = 'button';
      decrease.textContent = '−';
      decrease.setAttribute('aria-label', 'Decrease quantity');
      quantity.insertBefore(decrease, input);
      buttons = [decrease, ...buttons];
    }
    const decrease = buttons[0];
    const increase = buttons[buttons.length - 1];
    decrease.type = 'button'; increase.type = 'button';
    decrease.setAttribute('aria-label', 'Decrease quantity');
    increase.setAttribute('aria-label', 'Increase quantity');
    decrease.addEventListener('click', () => set(clamp(input.value) - 1));
    increase.addEventListener('click', () => set(clamp(input.value) + 1));
    input.addEventListener('change', () => { input.value = String(clamp(input.value)); });
    input.addEventListener('blur', () => { input.value = String(clamp(input.value)); });
  };

  const bindProductAccordions = detail => {
    detail?.querySelectorAll('.tabs details').forEach((item, index) => {
      const summary = item.querySelector(':scope > summary');
      const panel = item.querySelector(':scope > :not(summary)');
      if (!summary || !panel || item.dataset.accordionBound === 'true') return;
      item.dataset.accordionBound = 'true';
      const panelId = panel.id || `fd-product-accordion-panel-${index + 1}`;
      panel.id = panelId;
      summary.setAttribute('aria-controls', panelId);
      summary.setAttribute('aria-expanded', item.open ? 'true' : 'false');
      item.addEventListener('toggle', () => summary.setAttribute('aria-expanded', item.open ? 'true' : 'false'));
    });
  };

  const start=()=>{
    const detail=document.querySelector('.product-detail');if(!detail)return;
    bindQuantityControl(detail);
    bindProductAccordions(detail);
    const columns=detail.querySelectorAll(':scope > .shell > div'),copy=columns[1];if(!copy)return;
    [copy.querySelector(':scope > p'),copy.querySelector('.tabs details:first-of-type > p')].filter(Boolean).forEach(target=>{
      const observer=new MutationObserver(()=>{observer.disconnect();queueMicrotask(()=>format(target))});observer.observe(target,{childList:true,subtree:true,characterData:true});setTimeout(()=>{observer.disconnect();format(target)},2500);
    });
  };
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
