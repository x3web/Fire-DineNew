(() => {
  'use strict';

  const path = location.pathname.replace(/\/+$/, '') || '/';
  if (path !== '/' && path !== '/index.html') return;

  const cleanStoneSkinTrademark = () => {
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    nodes.forEach(node => {
      node.nodeValue = String(node.nodeValue || '').replace(/StoneSkin\s*(?:™|&trade;)/gi, 'StoneSkin');
    });
  };

  cleanStoneSkinTrademark();

  const formatPrice = product => {
    const min = product.variation_min_price;
    const max = product.variation_max_price;
    if (min !== null && min !== undefined && Number(min) > 0) {
      if (max !== null && max !== undefined && Number(max) > 0 && Number(min) !== Number(max)) {
        return `R${Number(min).toFixed(2)} - R${Number(max).toFixed(2)}`;
      }
      return `R${Number(min).toFixed(2)}`;
    }

    const current = product.sale_price || product.regular_price;
    return Number(current) > 0 ? `R${Number(current).toFixed(2)}` : 'Request current pricing';
  };

  const plainText = value => {
    const wrapper = document.createElement('div');
    wrapper.innerHTML = String(value || '');
    return (wrapper.textContent || '').replace(/\s+/g, ' ').trim();
  };

  const buildProductCard = product => {
    const article = document.createElement('article');
    article.className = 'product';

    const productUrl = `/product?slug=${encodeURIComponent(product.slug)}`;

    const media = document.createElement('a');
    media.href = productUrl;
    media.setAttribute('aria-label', `View ${product.name}`);

    if (product.image_url) {
      const image = document.createElement('img');
      image.src = product.image_url;
      image.alt = product.name || 'Fire & Dine product';
      image.loading = 'lazy';
      image.decoding = 'async';
      media.append(image);
    } else {
      const placeholder = document.createElement('span');
      placeholder.className = 'product-image-placeholder';
      placeholder.textContent = 'Image coming soon';
      media.append(placeholder);
    }

    const info = document.createElement('div');
    info.className = 'product-info';

    const category = document.createElement('span');
    category.className = 'eyebrow';
    category.textContent = product.category || 'Product';

    const name = document.createElement('h3');
    name.textContent = product.name || 'Fire & Dine Product';

    const spec = document.createElement('div');
    spec.className = 'spec';
    spec.textContent = plainText(product.short_description) || product.brand || 'Fire & Dine product';

    const price = document.createElement('div');
    price.className = 'price';
    price.textContent = formatPrice(product);

    const actions = document.createElement('div');
    actions.className = 'fd-product-actions';

    const details = document.createElement('a');
    details.className = 'btn btn-outline';
    details.href = productUrl;
    details.textContent = 'View Details';

    const quote = document.createElement('a');
    quote.className = 'btn btn-outline';
    quote.href = '/contact?subject=quote';
    quote.textContent = 'Request Quote';

    actions.append(details, quote);
    info.append(category, name, spec, price, actions);
    article.append(media, info);
    return article;
  };

  document.addEventListener('DOMContentLoaded', async () => {
    cleanStoneSkinTrademark();
    const grid = document.querySelector('.featured-section .products');
    if (!grid) return;

    grid.replaceChildren();
    grid.setAttribute('aria-busy', 'true');

    const showFallback = message => {
      const fallback = document.createElement('div');
      fallback.className = 'featured-products-fallback';
      const copy = document.createElement('p');
      copy.textContent = message;
      const link = document.createElement('a');
      link.className = 'btn btn-gold';
      link.href = '/shop';
      link.textContent = 'View Our Full Range';
      fallback.append(copy, link);
      grid.replaceChildren(fallback);
    };

    try {
      const response = await fetch('/api/products?featured=1&limit=4', { headers: { Accept: 'application/json' } });
      if (!response.ok) throw new Error('Featured products unavailable');

      const payload = await response.json();
      const products = Array.isArray(payload.products) ? payload.products : [];
      if (!products.length) {
        showFallback('Explore the full Fire & Dine range to find the right fit for your space.');
        return;
      }

      grid.replaceChildren(...products.map(buildProductCard));
    } catch (_) {
      showFallback('Featured products are temporarily unavailable.');
    } finally {
      grid.removeAttribute('aria-busy');
    }
  });
})();
