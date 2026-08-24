<?php
declare(strict_types=1);

$head = <<<'HTML'

    <meta charset="utf-8" />
    <meta content="width=device-width,initial-scale=1" name="viewport" />
    <link
      href="assets/images/logo/fire-dine-site-icon.webp"
      rel="icon"
      type="image/webp"
    />
    <link
      href="assets/images/logo/fire-dine-site-icon.webp"
      rel="apple-touch-icon"
    />
    <title>Contact Fire &amp; Dine | Product Advice &amp; Quotes</title>
    <meta
      content="Contact Fire &amp; Dine for product guidance, installation support and quotation enquiries."
      name="description"
    />
    <link href="https://fireanddine.co.za/contact" rel="canonical" />
    <meta
      content="Contact Fire &amp; Dine | Product Advice &amp; Quotes"
      property="og:title"
    />
    <meta
      content="Contact Fire &amp; Dine for product guidance, installation support and quotation enquiries."
      property="og:description"
    />
    <meta content="https://fireanddine.co.za/contact" property="og:url" />
    <meta content="website" property="og:type" />
    <link href="assets/fonts/fontawesome/css/all.min.css" rel="stylesheet" />
    <link href="assets/css/fire-dine-premium.css" rel="stylesheet" /><link href="/assets/css/design-system.css" rel="stylesheet"/>
    <style>
      .contact-get-started {
        position: relative;
        padding: 92px 0 96px;
        overflow: hidden;
        background:
          radial-gradient(
            circle at 18% 20%,
            rgba(201, 146, 42, 0.18),
            transparent 28%
          ),
          radial-gradient(
            circle at 84% 32%,
            rgba(19, 51, 91, 0.18),
            transparent 30%
          ),
          radial-gradient(
            circle at 52% 78%,
            rgba(201, 146, 42, 0.08),
            transparent 28%
          ),
          linear-gradient(180deg, #070809 0%, #090a0d 48%, #060708 100%);
      }
      .contact-get-started::before {
        content: "";
        position: absolute;
        inset: 0;
        background:
          linear-gradient(
            90deg,
            rgba(255, 255, 255, 0.02) 0,
            rgba(255, 255, 255, 0) 24%,
            rgba(255, 255, 255, 0.02) 50%,
            rgba(255, 255, 255, 0) 76%,
            rgba(255, 255, 255, 0.02) 100%
          ),
          radial-gradient(
            circle at center,
            rgba(255, 255, 255, 0.02) 0,
            transparent 65%
          );
        opacity: 0.45;
        pointer-events: none;
      }
      .contact-get-started .shell {
        position: relative;
        z-index: 1;
        max-width: 1320px;
      }
      .cgs-header {
        max-width: 1140px;
        margin: 0 auto 34px;
        text-align: center;
        color: #fff;
      }
      .cgs-kicker {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 18px;
        text-transform: uppercase;
        letter-spacing: 0.22em;
        color: #d4a14c;
        font-size: 14px;
        font-weight: 700;
      }
      .cgs-kicker::before,
      .cgs-kicker::after {
        content: "";
        width: 138px;
        height: 1px;
        background: linear-gradient(
          90deg,
          rgba(212, 161, 76, 0),
          rgba(212, 161, 76, 0.95) 58%,
          rgba(212, 161, 76, 0.95) 100%
        );
      }
      .cgs-kicker::after {
        background: linear-gradient(
          90deg,
          rgba(212, 161, 76, 0.95),
          rgba(212, 161, 76, 0.95) 42%,
          rgba(212, 161, 76, 0) 100%
        );
      }
      .cgs-kicker-badge {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        border: 2px solid #d4a14c;
        display: grid;
        place-items: center;
        font-size: 18px;
        box-shadow: 0 0 0 4px rgba(212, 161, 76, 0.08);
      }
      .cgs-header h2 {
        font-family: inherit;
        font-size: clamp(54px, 6vw, 92px);
        line-height: 1.02;
        letter-spacing: -0.04em;
        color: #f8f6f2;
        margin: 18px 0 20px;
      }
      .cgs-rule {
        display: block;
        width: 82px;
        height: 3px;
        border-radius: 3px;
        background: #d4a14c;
        margin: 0 auto 22px;
      }
      .cgs-header p {
        max-width: 860px;
        margin: 0 auto;
        color: #dfdfdf;
        font-size: 18px;
        line-height: 1.5;
      }
      .cgs-cards {
        display: grid;
        gap: 18px;
        margin-top: 32px;
      }
      .cgs-card {
        position: relative;
        display: grid;
        grid-template-columns: 170px 1px 1fr 150px;
        align-items: center;
        gap: 28px;
        min-height: 206px;
        padding: 22px 36px 22px 34px;
        border: 1px solid rgba(212, 161, 76, 0.58);
        border-radius: 18px;
        background: linear-gradient(
          90deg,
          rgba(11, 16, 24, 0.82) 0%,
          rgba(8, 10, 14, 0.92) 58%,
          rgba(10, 12, 16, 0.96) 100%
        );
        box-shadow:
          inset 0 1px 0 rgba(255, 255, 255, 0.03),
          0 12px 32px rgba(0, 0, 0, 0.16);
      }
      .cgs-card-left {
        display: flex;
        justify-content: center;
      }
      .cgs-main-divider {
        width: 1px;
        height: 124px;
        background: rgba(212, 161, 76, 0.88);
      }
      .cgs-card-icon {
        width: 128px;
        height: 128px;
        border-radius: 50%;
        display: grid;
        place-items: center;
        border: 1px solid rgba(212, 161, 76, 0.5);
        color: #e1ac50;
        font-size: 60px;
        background: radial-gradient(
          circle at center,
          rgba(212, 161, 76, 0.16) 0%,
          rgba(212, 161, 76, 0.05) 52%,
          rgba(212, 161, 76, 0.02) 100%
        );
        box-shadow:
          0 0 28px rgba(212, 161, 76, 0.12),
          inset 0 0 18px rgba(212, 161, 76, 0.06);
      }
      .cgs-card-body {
        display: flex;
        align-items: flex-start;
        gap: 22px;
        padding-right: 12px;
      }
      .cgs-number {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        border: 2px solid #d4a14c;
        color: #e1ac50;
        flex: 0 0 auto;
        display: grid;
        place-items: center;
        font-size: 24px;
        font-weight: 700;
        line-height: 1;
        margin-top: 2px;
        box-shadow: 0 0 0 4px rgba(212, 161, 76, 0.07);
      }
      .cgs-card-copy h3 {
        margin: 2px 0 14px;
        color: #fff;
        font-size: 21px;
        line-height: 1.25;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.02em;
      }
      .cgs-card-copy .mini-rule {
        display: block;
        width: 42px;
        height: 3px;
        border-radius: 3px;
        background: #d4a14c;
        margin: 0 0 16px;
      }
      .cgs-card-copy p {
        margin: 0;
        color: #ededed;
        font-size: 16px;
        line-height: 1.75;
        max-width: 860px;
      }
      .cgs-card-decor {
        display: flex;
        justify-content: flex-end;
        align-self: stretch;
        align-items: center;
        pointer-events: none;
      }
      .cgs-card-decor i {
        font-size: 108px;
        color: rgba(170, 176, 186, 0.14);
        filter: drop-shadow(0 0 1px rgba(255, 255, 255, 0.04));
      }
      .cgs-tip {
        margin-top: 18px;
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 18px 26px;
        border: 1px solid rgba(212, 161, 76, 0.58);
        border-radius: 16px;
        background: linear-gradient(
          90deg,
          rgba(10, 13, 18, 0.84) 0%,
          rgba(7, 9, 12, 0.92) 100%
        );
        color: #eee;
        font-size: 18px;
        line-height: 1.5;
      }
      .cgs-tip-icon {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        border: 1.5px solid #d4a14c;
        color: #d4a14c;
        display: grid;
        place-items: center;
        flex: 0 0 auto;
        font-size: 17px;
      }
      .cgs-tip strong {
        color: #e1ac50;
      }
      @media (max-width: 1100px) {
        .contact-get-started {
          padding: 76px 0 84px;
        }
        .cgs-kicker::before,
        .cgs-kicker::after {
          width: 92px;
        }
        .cgs-card {
          grid-template-columns: 132px 1px 1fr 108px;
          gap: 22px;
          min-height: unset;
          padding: 22px 24px;
        }
        .cgs-card-icon {
          width: 104px;
          height: 104px;
          font-size: 48px;
        }
        .cgs-main-divider {
          height: 108px;
        }
        .cgs-card-body {
          gap: 18px;
        }
        .cgs-number {
          width: 54px;
          height: 54px;
          font-size: 22px;
        }
        .cgs-card-copy h3 {
          font-size: 18px;
        }
        .cgs-card-copy p {
          font-size: 15px;
        }
        .cgs-card-decor i {
          font-size: 88px;
        }
      }
      @media (max-width: 840px) {
        .cgs-header h2 {
          font-size: 60px;
        }
        .cgs-header p {
          font-size: 16px;
        }
        .cgs-card {
          grid-template-columns: 112px 1px 1fr 78px;
          gap: 18px;
          padding: 20px;
        }
        .cgs-card-icon {
          width: 86px;
          height: 86px;
          font-size: 40px;
        }
        .cgs-main-divider {
          height: 92px;
        }
        .cgs-card-body {
          display: grid;
          grid-template-columns: 52px 1fr;
          gap: 14px;
        }
        .cgs-number {
          width: 50px;
          height: 50px;
          font-size: 20px;
        }
        .cgs-card-copy h3 {
          font-size: 17px;
          margin-bottom: 10px;
        }
        .cgs-card-copy .mini-rule {
          margin-bottom: 12px;
        }
        .cgs-card-copy p {
          font-size: 14px;
          line-height: 1.7;
        }
        .cgs-card-decor i {
          font-size: 70px;
        }
        .cgs-tip {
          font-size: 16px;
        }
      }
      @media (max-width: 640px) {
        .contact-get-started {
          padding: 58px 0 64px;
        }
        .contact-get-started .shell {
          width: min(calc(100% - 26px), 1320px);
        }
        .cgs-kicker {
          font-size: 11px;
          letter-spacing: 0.16em;
          gap: 10px;
        }
        .cgs-kicker::before,
        .cgs-kicker::after {
          width: 42px;
        }
        .cgs-kicker-badge {
          width: 32px;
          height: 32px;
          font-size: 15px;
        }
        .cgs-header {
          margin-bottom: 26px;
        }
        .cgs-header h2 {
          font-size: 42px;
          margin: 14px 0 14px;
        }
        .cgs-rule {
          width: 70px;
          margin-bottom: 16px;
        }
        .cgs-header p {
          font-size: 14px;
        }
        .cgs-cards {
          gap: 14px;
        }
        .cgs-card {
          grid-template-columns: 1fr;
          gap: 16px;
          padding: 18px 16px 18px;
          border-radius: 14px;
        }
        .cgs-card-left {
          justify-content: flex-start;
        }
        .cgs-card-icon {
          width: 82px;
          height: 82px;
          font-size: 38px;
        }
        .cgs-main-divider {
          width: 100%;
          height: 1px;
        }
        .cgs-card-body {
          display: grid;
          grid-template-columns: 1fr;
          gap: 14px;
          padding-right: 0;
        }
        .cgs-number {
          width: 48px;
          height: 48px;
          font-size: 19px;
        }
        .cgs-card-copy h3 {
          font-size: 16px;
          line-height: 1.3;
          margin: 0 0 10px;
        }
        .cgs-card-copy .mini-rule {
          width: 36px;
          height: 2px;
          margin-bottom: 12px;
        }
        .cgs-card-copy p {
          font-size: 14px;
        }
        .cgs-card-decor {
          justify-content: flex-end;
          min-height: 42px;
        }
        .cgs-card-decor i {
          font-size: 52px;
        }
        .cgs-tip {
          padding: 16px;
          font-size: 14px;
          align-items: flex-start;
        }
        .cgs-tip-icon {
          width: 30px;
          height: 30px;
          font-size: 15px;
        }
      }
      section[data-kt-integrated="true"] .section-head .eyebrow,
      section[data-kt-integrated="true"] .section-head h2,
      section[data-kt-integrated="true"] .section-head p {
        color: #000 !important;
      }
    </style>
  
HTML;
$header = <<<'HTML'
<div class="page"><header class="header">
        <div class="shell">
          <a aria-label="Fire &amp; Dine home" class="logo" href="/"
            ><img
              alt="Fire &amp; Dine — Family Time Since 2013"
              src="assets/images/logo/fire-dine-header-logo.webp" /></a
          ><button
            aria-expanded="false"
            aria-label="Open navigation"
            class="menu-btn"
          >
            <i aria-hidden="true" class="fas fa-bars"></i>
          </button>
          <nav aria-label="Primary navigation" class="nav">
            <a href="/">Home</a><a href="/about">About Us</a
            ><a href="/shop">Shop</a><a href="/installation">Installation</a
            ><a href="/gallery">Gallery</a
            ><a aria-current="page" class="active" href="/contact"
              >Contact Us</a
            >
          </nav>
          <a aria-label="Cart" class="cart-link" href="/cart"
            ><i aria-hidden="true" class="fas fa-shopping-cart"></i
            ><span class="badge">0</span></a
          >
        </div>
      </header>
HTML;
$main = <<<'HTML'
<main>
        <section
          class="page-hero hero-image-selected"
          style="
            --hero-desktop: url(&quot;/assets/images/hero-selected/hero-02-craftsmanship-1920.webp&quot;);
            --hero-tablet: url(&quot;/assets/images/hero-selected/hero-02-craftsmanship-1440.webp&quot;);
            --hero-mobile: url(&quot;/assets/images/hero-selected/hero-02-craftsmanship-960.webp&quot;);
            --hero-position: center center;
            --hero-position-mobile: 57% center;
          "
        >
          <div class="shell">
            <span class="eyebrow">Product advice and quotations</span>
            <h1>Contact Us</h1>
            <p>
              Tell us about the product, space, delivery location or
              installation support you need.
            </p>
          </div>
        </section>
        <section
          aria-labelledby="contact-get-started-title"
          class="contact-get-started"
        >
          <div class="shell">
            <header class="cgs-header">
              <div class="cgs-kicker">
                <span class="cgs-kicker-badge"
                  ><i aria-hidden="true" class="fas fa-fire"></i></span
                ><span>Get Started</span>
              </div>
              <h2 id="contact-get-started-title">
                Let’s Talk About Your Project
              </h2>
              <span aria-hidden="true" class="cgs-rule"></span>
              <p>
                The more information you provide, the better we can understand
                your needs and guide you to the perfect solution.
              </p>
            </header>
            <div class="cgs-cards">
              <article class="cgs-card">
                <div class="cgs-card-left">
                  <div class="cgs-card-icon">
                    <i aria-hidden="true" class="fas fa-clipboard-list"></i>
                  </div>
                </div>
                <div aria-hidden="true" class="cgs-main-divider"></div>
                <div class="cgs-card-body">
                  <div class="cgs-number">01</div>
                  <div class="cgs-card-copy">
                    <h3>TELL US ABOUT YOUR PROJECT</h3>
                    <span aria-hidden="true" class="mini-rule"></span>
                    <p>
                      Share your product interest, available space, delivery
                      location, preferred size, customisation requirements and
                      installation needs so we can provide relevant advice.
                    </p>
                  </div>
                </div>
                <div class="cgs-card-decor">
                  <i aria-hidden="true" class="far fa-comments"></i>
                </div>
              </article>
              <article class="cgs-card">
                <div class="cgs-card-left">
                  <div class="cgs-card-icon">
                    <i aria-hidden="true" class="fas fa-store"></i>
                  </div>
                </div>
                <div aria-hidden="true" class="cgs-main-divider"></div>
                <div class="cgs-card-body">
                  <div class="cgs-number">02</div>
                  <div class="cgs-card-copy">
                    <h3>PLANNING A COMMERCIAL INSTALLATION?</h3>
                    <span aria-hidden="true" class="mini-rule"></span>
                    <p>
                      Include your business type, expected cooking volume,
                      available installation space, oven capacity, delivery
                      location and expected project timeline.
                    </p>
                  </div>
                </div>
                <div class="cgs-card-decor">
                  <i aria-hidden="true" class="far fa-clipboard"></i>
                </div>
              </article>
              <article class="cgs-card">
                <div class="cgs-card-left">
                  <div class="cgs-card-icon">
                    <i aria-hidden="true" class="fas fa-headset"></i>
                  </div>
                </div>
                <div aria-hidden="true" class="cgs-main-divider"></div>
                <div class="cgs-card-body">
                  <div class="cgs-number">03</div>
                  <div class="cgs-card-copy">
                    <h3>NEED INSTALLATION OR MAINTENANCE ADVICE?</h3>
                    <span aria-hidden="true" class="mini-rule"></span>
                    <p>
                      Send the product name, photographs of the product and
                      installation area, a description of the issue,
                      installation date and maintenance already completed.
                    </p>
                  </div>
                </div>
                <div class="cgs-card-decor">
                  <i aria-hidden="true" class="fas fa-tools"></i>
                </div>
              </article>
            </div>
            <div class="cgs-tip">
              <span class="cgs-tip-icon"
                ><i aria-hidden="true" class="fas fa-info"></i
              ></span>
              <p>
                <strong>Tip:</strong> Photos and measurements help us respond
                faster and more accurately.
              </p>
            </div>
          </div>
        </section>
        <section class="section">
          <div class="shell two-col">
            <aside class="content-box contact-details">
              <h2>Visit or Get in Touch</h2>
              <address>
                <p>
                  <i aria-hidden="true" class="fas fa-map-marker-alt gold"></i>
                  Vanderbijlpark, Gauteng
                </p>
                <p>
                  <i aria-hidden="true" class="fas fa-phone gold"></i>
                  <a href="tel:+27834381485">083 438 1485</a> /
                  <a href="tel:+27160130411"></a>
                </p>
                <p>
                  <i aria-hidden="true" class="fas fa-envelope gold"></i>
                  <a href="mailto:info@fireanddine.co.za"
                    >info@fireanddine.co.za</a
                  >
                </p>
              </address>
              <div class="actions">
                <a
                  class="btn btn-gold"
                  href="https://wa.me/27834381485"
                  rel="noopener noreferrer"
                  target="_blank"
                  >WhatsApp</a
                ><a class="btn btn-outline" href="tel:+27834381485"
                  >Call Our Team</a
                >
              </div>
              <p class="form-note">
                For technical support, include the product name, installation
                photographs and a description of the issue.
              </p>
            </aside>
            <div class="content-box">
              <h2>Send an Enquiry</h2>
              <form
                class="form-grid"
                action="/api/enquiries"
                data-static-contact=""
                enctype="multipart/form-data"
                id="contact-form"
                method="post"
                novalidate=""
              >
                <label
                  >First Name<input
                    autocomplete="given-name"
                    class="form-control"
                    name="firstName"
                    required="" /></label
                ><label
                  >Last Name<input
                    autocomplete="family-name"
                    class="form-control"
                    name="lastName"
                    required="" /></label
                ><label class="full"
                  >Email Address<input
                    autocomplete="email"
                    class="form-control"
                    name="email"
                    required=""
                    type="email" /></label
                ><label class="full"
                  >Phone Number<input
                    autocomplete="tel"
                    class="form-control"
                    name="phone"
                    required=""
                    type="tel" /></label
                ><label
                  >Residential or Commercial<select
                    class="form-control"
                    name="application"
                    required=""
                  >
                    <option value="">Select one</option>
                    <option>Residential</option>
                    <option>Commercial</option>
                  </select></label
                ><label
                  >Product of Interest<select
                    class="form-control"
                    name="product"
                    required=""
                  >
                    <option value="">Select a product category</option>
                    <option>Pizza oven</option>
                    <option>Commercial pizza oven</option>
                    <option>Fireplace</option>
                    <option>Accessories</option>
                    <option>Installation support</option>
                    <option>Maintenance support</option>
                  </select></label
                ><label class="full"
                  >Province or Delivery Location<input
                    autocomplete="address-level1"
                    class="form-control"
                    name="location"
                    required="" /></label
                ><label class="full"
                  >Available Space or Measurements<input
                    class="form-control"
                    name="measurements"
                    placeholder="Add measurements if available" /></label
                ><label class="full"
                  >Message<textarea
                    class="form-control"
                    name="message"
                    required=""
                    rows="5"
                  ></textarea></label
                ><label class="full"
                  >Photograph or Plan Upload
                  <span class="spec"
                    >(optional; image or PDF, maximum 10 MB)</span
                  ><input
                    accept="image/*,.pdf"
                    class="form-control"
                    name="attachment"
                    type="file" /></label
                ><label class="full"
                  >Preferred Contact Method<select
                    class="form-control"
                    name="preferredContact"
                  >
                    <option>Email</option>
                    <option>Phone</option>
                    <option>WhatsApp</option>
                  </select></label
                >
                <div aria-hidden="true" class="honeypot">
                  <label
                    >Leave this field empty<input
                      autocomplete="off"
                      name="website"
                      tabindex="-1"
                  /></label>
                </div>
                <button class="btn btn-gold full" type="submit">
                  Send Enquiry
                </button>
                <div
                  aria-live="polite"
                  class="form-status full"
                  role="status"
                ></div>
              </form>
            </div>
          </div>
        </section>
        <section class="section fd-alt-white" style="padding-top: 0">
          <div class="shell">
            <div class="map">
              <div>
                <i
                  aria-hidden="true"
                  class="fas fa-map-marker-alt gold"
                  style="font-size: 40px"
                ></i>
                <h2>Our Showroom</h2>
                <p>Vanderbijlpark, Gauteng</p>
                <a
                  class="btn btn-outline"
                  href="https://maps.google.com/?q=31+Springbok+Ave+Vanderbijlpark"
                  rel="noopener noreferrer"
                  target="_blank"
                  >Open Map</a
                >
              </div>
            </div>
          </div>
        </section>
        <section class="section" data-kt-integrated="true">
          <div class="shell">
            <header class="section-head">
              <span class="eyebrow">Confirmed contact details</span>
              <h2>WhatsApp Is the Fastest Way to Reach Fire and Dine</h2>
              <p>
                The primary sales channel is WhatsApp. Fire and Dine is based in
                Vanderbijlpark, Gauteng, and delivers nationwide across South
                Africa.
              </p>
            </header>
            <div class="contact-facts">
              <a href="https://wa.me/27834381485"
                ><i aria-hidden="true" class="fab fa-whatsapp"></i
                ><strong>083 438 1485</strong><span>WhatsApp / phone</span></a
              ><a href="mailto:Info@fireanddine.co.za"
                ><i aria-hidden="true" class="fas fa-envelope"></i
                ><strong>Info@fireanddine.co.za</strong><span>Email</span></a
              >
              <div>
                <i aria-hidden="true" class="fas fa-map-marker-alt"></i
                ><strong>Vanderbijlpark, Gauteng</strong
                ><span>Workshop &amp; showroom</span>
              </div>
            </div>
            <p class="supporting-note">
              The exact street address and business hours are not published here
              because they require confirmation. Contact the team before
              travelling to the showroom.
            </p>
          </div>
        </section>
        <section
          class="cta site-final-cta"
          style="
            background-image:
              linear-gradient(rgba(5, 6, 6, 0.78), rgba(5, 6, 6, 0.92)),
              url(&quot;assets/images/fire-and-dine/cta/cta-01-design-consultation.webp&quot;);
          "
        >
          <div class="shell">
            <span class="eyebrow">Start your project</span>
            <h2>Bring Your Fire &amp; Dine Space to Life</h2>
            <p>
              Tell us about your space, preferred product and location, and our
              team will help you plan the right next step.
            </p>
            <div class="actions">
              <a class="btn btn-gold" href="/contact?subject=quote"
                >Request a Quote</a
              >
            </div>
          </div>
        </section>
      </main>
HTML;
$footer = <<<'HTML'
<footer class="footer">
        <div class="shell footer-grid">
          <div class="footer-col footer-brand">
            <img
              alt="Fire &amp; Dine — Family Time Since 2013"
              class="footer-logo"
              src="assets/images/logo/fire-dine-footer-logo.webp"
            />
          </div>
          <div class="footer-col policy-links">
            <h3>Policies</h3>
            <a href="/privacy-policy"
              ><i aria-hidden="true" class="fas fa-user-shield gold"></i
              ><span>Privacy Policy</span></a
            ><a href="/terms"
              ><i aria-hidden="true" class="fas fa-file-contract gold"></i
              ><span>Terms of Service</span></a
            >
          </div>
        </div>
        <div class="copyright">
          <span class="copyright-sep">|</span
          ><a class="gold" href="/privacy-policy">Privacy Policy</a>
        </div>
      </footer></div>
HTML;
$scripts = <<<'HTML'
<script src="assets/js/fire-dine-premium.js"></script>
    <script src="/assets/js/x3-tracking.js"></script>
    <script src="/assets/js/brochure-widget.js"></script>
  
HTML;
require dirname(__DIR__) . '/layouts/app.php';
