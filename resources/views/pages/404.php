<?php
declare(strict_types=1);

$head = <<<'HTML'
<meta charset="utf-8"/><meta content="width=device-width,initial-scale=1" name="viewport"/><link href="assets/images/logo/fire-dine-site-icon.webp" rel="icon" type="image/webp"/><link href="assets/images/logo/fire-dine-site-icon.webp" rel="apple-touch-icon"/><title>Page Not Found | Fire &amp; Dine</title><meta content="noindex" name="robots"/><link href="assets/fonts/fontawesome/css/all.min.css" rel="stylesheet"/><link href="assets/css/fire-dine-premium.css" rel="stylesheet"/><link href="/assets/css/design-system.css" rel="stylesheet"/>
HTML;
$header = <<<'HTML'
<div class="page"><header class="header"><div class="shell"><a class="logo" href="/"><img alt="Fire &amp; Dine — Family Time Since 2013" src="assets/images/logo/fire-dine-header-logo.webp"/></a><button aria-expanded="false" aria-label="Open navigation" class="menu-btn"><i class="fas fa-bars"></i></button><nav aria-label="Primary navigation" class="nav"><a href="/">Home</a><a href="/about">About Us</a><a href="/shop">Shop</a><a href="/installation">Installation</a><a href="/gallery">Gallery</a><a href="/contact">Contact Us</a></nav></div></header>
HTML;
$main = <<<'HTML'
<main><section class="page-hero hero-image-selected" style="min-height:70vh;display:grid;place-items:center;--hero-desktop:url('assets/images/hero-selected/hero-03-city-view-terrace-1920.webp');--hero-tablet:url('assets/images/hero-selected/hero-03-city-view-terrace-1440.webp');--hero-mobile:url('assets/images/hero-selected/hero-03-city-view-terrace-960.webp');--hero-position:center center;--hero-position-mobile:68% center;"><div class="shell"><span class="eyebrow">404 • Page not found</span><h1>Looks Like the Fire Has Gone Out</h1><p>The page may have moved, but the collection is still burning bright.</p><div class="actions"><a class="btn btn-gold" href="/">Return Home</a><a class="btn btn-outline" href="/shop">Explore Pizza Ovens</a><a class="btn btn-outline" href="/contact">Contact Us</a></div></div></section><section class="cta site-final-cta" style="background-image:linear-gradient(rgba(5,6,6,.78),rgba(5,6,6,.92)),url('assets/images/fire-and-dine/cta/cta-05-request-quote.webp');"><div class="shell"><span class="eyebrow">Start your project</span><h2>Bring Your Fire &amp; Dine Space to Life</h2><p>Tell us about your space, preferred product and location, and our team will help you plan the right next step.</p><div class="actions"><a class="btn btn-gold" href="/contact?subject=quote">Request a Quote</a></div></div></section></main>
HTML;
$footer = <<<'HTML'
<footer class="footer"><div class="shell footer-grid"><div class="footer-col footer-brand"><img alt="Fire &amp; Dine — Family Time Since 2013" class="footer-logo" src="assets/images/logo/fire-dine-footer-logo.webp"/></div><div class="footer-col"><h3>Quick Links</h3><a href="/stoneskin">StoneSkin</a></div><div class="footer-col footer-contact"><h3>Contact Us</h3></div><div class="footer-col"><h3>Stay Connected</h3></div><div class="footer-col policy-links"><h3>Policies</h3><a href="/privacy-policy"><i aria-hidden="true" class="fas fa-user-shield gold"></i><span>Privacy Policy</span></a><a href="/terms"><i aria-hidden="true" class="fas fa-file-contract gold"></i><span>Terms of Service</span></a></div></div><div class="copyright"><span class="copyright-sep">|</span><a class="gold" href="/privacy-policy">Privacy Policy</a></div></footer></div>
HTML;
$scripts = <<<'HTML'
<script src="assets/js/fire-dine-premium.js"></script><script src="/assets/js/x3-tracking.js"></script><script src="/assets/js/brochure-widget.js"></script>
HTML;
require dirname(__DIR__) . '/layouts/app.php';
