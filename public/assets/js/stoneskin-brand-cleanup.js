(() => {
  'use strict';

  const clean = value => String(value || '')
    .replace(/StoneSkin\s*(?:™|&trade;)/gi, match => match.toLowerCase().startsWith('stoneskin') ? 'StoneSkin' : match);

  const cleanTextNodes = root => {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    nodes.forEach(node => {
      const next = clean(node.nodeValue);
      if (next !== node.nodeValue) node.nodeValue = next;
    });
  };

  const cleanAttributes = root => {
    root.querySelectorAll?.('[title],[aria-label],[alt]').forEach(element => {
      ['title', 'aria-label', 'alt'].forEach(attribute => {
        if (!element.hasAttribute(attribute)) return;
        const current = element.getAttribute(attribute);
        const next = clean(current);
        if (next !== current) element.setAttribute(attribute, next);
      });
    });
  };

  const cleanHead = () => {
    const title = clean(document.title);
    if (title !== document.title) document.title = title;
    document.querySelectorAll('meta[content]').forEach(meta => {
      const current = meta.getAttribute('content');
      const next = clean(current);
      if (next !== current) meta.setAttribute('content', next);
    });
  };

  const cleanPage = () => {
    cleanHead();
    cleanTextNodes(document.body);
    cleanAttributes(document.body);
  };

  const start = () => {
    cleanPage();
    requestAnimationFrame(cleanPage);
    window.addEventListener('load', cleanPage, { once: true });
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', start, { once: true });
  } else {
    start();
  }
})();
