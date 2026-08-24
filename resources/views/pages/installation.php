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
    <title>Pizza Oven Installation &amp; Maintenance | Fire &amp; Dine</title>
    <meta
      content="Installation, curing, safe use and ongoing maintenance guidance for Fire &amp; Dine pizza ovens and fireplaces."
      name="description"
    />
    <link href="https://fireanddine.co.za/installation" rel="canonical" />
    <meta
      content="Pizza Oven Installation &amp; Maintenance | Fire &amp; Dine"
      property="og:title"
    />
    <meta
      content="Installation, curing, safe use and ongoing maintenance guidance for Fire &amp; Dine products."
      property="og:description"
    />
    <meta content="https://fireanddine.co.za/installation" property="og:url" />
    <meta content="website" property="og:type" />
    <link href="assets/fonts/fontawesome/css/all.min.css" rel="stylesheet" />
    <link href="assets/css/fire-dine-premium.css" rel="stylesheet" />
    <link href="/assets/css/design-system.css" rel="stylesheet" />
    <style>
      .installation-page {
        background: #fbfaf7;
        color: #121212;
      }
      .install-guidance-page {
        padding: 88px 0 96px;
        background: linear-gradient(180deg, #fcfbf8 0%, #faf8f5 100%);
      }
      .install-guidance-shell {
        max-width: 1320px;
      }
      .install-guidance-header {
        max-width: 1040px;
        margin: 0 auto 34px;
        text-align: center;
      }
      .install-guidance-kicker {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 14px;
        color: #c48a24;
        text-transform: uppercase;
        letter-spacing: 0.18em;
        font-size: 14px;
        font-weight: 700;
      }
      .install-guidance-kicker i {
        font-size: 14px;
      }
      .install-guidance-header h1 {
        font-family: inherit;
        font-size: clamp(46px, 5.5vw, 78px);
        line-height: 1.02;
        letter-spacing: -0.04em;
        color: #0f0f0f;
        margin: 18px 0 18px;
      }
      .install-guidance-rule {
        display: block;
        width: 66px;
        height: 3px;
        background: #c48a24;
        border-radius: 3px;
        margin: 0 auto 24px;
      }
      .install-guidance-header p {
        margin: 0;
        color: #454545;
        font-size: 17px;
        line-height: 1.5;
      }
      .install-guide-list {
        display: grid;
        gap: 16px;
        margin-top: 30px;
      }
      .install-guide-card {
        background: #f7f5f0;
        border: 1px solid #dad5cb;
        border-radius: 14px;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
        overflow: hidden;
        position: relative;
      }
      .install-guide-card summary {
        list-style: none;
        cursor: pointer;
      }
      .install-guide-card summary::-webkit-details-marker {
        display: none;
      }
      .guide-control {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        display: grid;
        place-items: center;
        background: #c9922a;
        color: #fff;
        font-size: 13px;
        flex: 0 0 auto;
      }
      .install-guide-card--open > summary {
        position: absolute;
        top: 22px;
        right: 22px;
        z-index: 3;
      }
      .guide-open-layout {
        display: grid;
        grid-template-columns: minmax(270px, 350px) minmax(320px, 1fr) 300px;
        align-items: center;
        gap: 26px;
        padding: 28px 28px;
      }
      .guide-open-intro {
        display: grid;
        grid-template-columns: 88px 1fr;
        gap: 22px;
        align-items: start;
        padding: 28px 18px 28px 6px;
        border-right: 1px solid #e0dbd2;
        min-height: 100%;
      }
      .guide-icon-circle {
        width: 82px;
        height: 82px;
        border-radius: 50%;
        background: #f2ede5;
        border: 1px solid #e1c890;
        display: grid;
        place-items: center;
        color: #c48a24;
        font-size: 34px;
      }
      .guide-icon-circle.small {
        width: 68px;
        height: 68px;
        font-size: 28px;
        border: 0;
        background: #f1ece4;
      }
      .guide-open-title-wrap {
        padding-top: 4px;
      }
      .guide-step-no {
        font-size: 23px;
        line-height: 1;
        font-weight: 700;
        color: #c48a24;
      }
      .guide-open-title-wrap h2 {
        font-family: inherit;
        color: #101010;
        font-size: 27px;
        line-height: 1.24;
        letter-spacing: -0.03em;
        margin: 14px 0 18px;
      }
      .guide-open-title-wrap p {
        margin: 0;
        color: #4f4d4a;
        font-size: 15px;
        line-height: 1.8;
        max-width: 260px;
      }
      .guide-open-details {
        display: grid;
        gap: 38px;
        padding: 20px 8px 20px 10px;
      }
      .guide-detail-block {
        display: grid;
        grid-template-columns: 44px 1fr;
        gap: 18px;
        align-items: start;
      }
      .guide-detail-icon {
        color: #c48a24;
        font-size: 34px;
        line-height: 1;
        margin-top: 2px;
      }
      .guide-detail-block h3 {
        margin: 0 0 10px;
        color: #131313;
        font-size: 15px;
        line-height: 1.35;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.06em;
      }
      .guide-detail-block p {
        margin: 0;
        color: #4a4947;
        font-size: 14px;
        line-height: 1.85;
      }
      .guide-open-image {
        display: flex;
        justify-content: flex-end;
      }
      .guide-open-image img {
        width: 100%;
        max-width: 300px;
        height: 230px;
        object-fit: cover;
        border-radius: 18px;
        display: block;
      }
      .install-guide-card--compact summary {
        display: grid;
        grid-template-columns: 96px 58px minmax(220px, 280px) 1fr 32px;
        gap: 18px;
        align-items: center;
        padding: 14px 28px;
      }
      .guide-row-title {
        font-family: inherit;
        color: #131313;
        font-size: 23px;
        line-height: 1.2;
        font-weight: 700;
        letter-spacing: -0.03em;
      }
      .guide-row-copy {
        color: #55524f;
        font-size: 15px;
        line-height: 1.65;
      }
      .guide-row-icon {
        display: flex;
        justify-content: center;
      }
      .guide-compact-body {
        display: grid;
        grid-template-rows: 0fr;
        transition: grid-template-rows 0.32s ease;
      }
      .install-guide-card--compact[open] .guide-compact-body {
        grid-template-rows: 1fr;
      }
      .guide-compact-body p {
        overflow: hidden;
        margin: 0;
        padding: 0 28px 24px 200px;
        color: #57524d;
        font-size: 15px;
        line-height: 1.75;
      }
      .install-guide-card--compact[open] summary {
        border-bottom: 1px solid #e2ddd4;
      }
      .install-guide-card--compact .guide-control i {
        transition: transform 0.25s ease;
      }
      .install-guide-card--compact[open] .guide-control i {
        transform: rotate(45deg);
      }
      .install-guidance-note {
        margin-top: 28px;
        background: #f8f7f3;
        border: 1px solid #ddd7cf;
        border-radius: 14px;
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 19px 24px;
      }
      .install-guidance-note i {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        background: #f3efe6;
        display: grid;
        place-items: center;
        color: #c48a24;
        font-size: 22px;
      }
      .install-guidance-note p {
        margin: 0;
        color: #313131;
        font-size: 15px;
        line-height: 1.6;
      }
      .install-guidance-note strong {
        font-weight: 700;
      }
      .install-guide-summary {
        margin-top: 34px;
        padding: 32px;
        background: #fff;
        border: 1px solid #ddd7cf;
        border-radius: 18px;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
      }
      .install-guide-summary header {
        text-align: center;
        max-width: 760px;
        margin: 0 auto 28px;
      }
      .install-guide-summary h3 {
        margin: 8px 0 10px;
        color: #101010;
        font-size: 32px;
        line-height: 1.08;
        letter-spacing: -0.03em;
      }
      .install-guide-summary header p {
        margin: 0;
        color: #4a4947;
        font-size: 15px;
        line-height: 1.7;
      }
      .install-guide-summary-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
      }
      .install-guide-summary-grid article {
        padding: 22px;
        border: 1px solid #e1dbd2;
        background: #faf8f4;
      }
      .install-guide-summary-grid h4 {
        margin: 0 0 10px;
        color: #131313;
        font-size: 15px;
        text-transform: uppercase;
        letter-spacing: 0.06em;
      }
      .install-guide-summary-grid p,
      .install-guide-summary-grid li {
        color: #4a4947;
        font-size: 14px;
        line-height: 1.75;
      }
      .install-guide-summary-grid p {
        margin: 0;
      }
      .install-guide-summary-grid ul {
        margin: 0;
        padding-left: 20px;
      }
      .install-guide-summary .stand-sizes {
        grid-column: 1/-1;
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 14px;
      }
      .install-guide-summary .stand-sizes span {
        display: grid;
        gap: 3px;
        padding: 16px;
        text-align: center;
        background: #f7f3ec;
        border: 1px solid #e1dbd2;
        color: #4a4947;
        font-size: 14px;
      }
      .install-guide-summary .stand-sizes strong {
        color: #131313;
        font-size: 15px;
        text-transform: uppercase;
        letter-spacing: 0.06em;
      }
      .install-guide-summary .summary-note {
        margin: 18px 0 0;
        text-align: center;
        color: #4a4947;
        font-size: 14px;
        line-height: 1.65;
      }
      @media (max-width: 640px) {
        .install-guide-summary {
          margin-top: 24px;
          padding: 22px 18px;
        }
        .install-guide-summary h3 {
          font-size: 26px;
        }
        .install-guide-summary-grid,
        .install-guide-summary .stand-sizes {
          grid-template-columns: 1fr;
        }
        .install-guide-summary-grid article {
          padding: 18px;
        }
      }
      @media (max-width: 1180px) {
        .guide-open-layout {
          grid-template-columns: 1fr;
          gap: 22px;
        }
        .guide-open-intro {
          border-right: 0;
          border-bottom: 1px solid #e0dbd2;
          padding: 8px 0 24px;
        }
        .guide-open-image {
          justify-content: flex-start;
        }
        .guide-open-image img {
          max-width: 420px;
        }
        .install-guide-card--compact summary {
          grid-template-columns: 88px 48px minmax(180px, 260px) 1fr 32px;
        }
      }
      @media (max-width: 900px) {
        .install-guidance-page {
          padding: 64px 0 72px;
        }
        .install-guidance-header h1 {
          font-size: 54px;
        }
        .install-guidance-header p {
          font-size: 16px;
        }
        .install-guide-card--compact summary {
          grid-template-columns: 74px 44px 1fr 28px;
          grid-template-areas: "icon num title control" ". . copy .";
          align-items: center;
        }
        .install-guide-card--compact summary .guide-row-icon {
          grid-area: icon;
        }
        .install-guide-card--compact summary .guide-step-no {
          grid-area: num;
        }
        .install-guide-card--compact summary .guide-row-title {
          grid-area: title;
        }
        .install-guide-card--compact summary .guide-row-copy {
          grid-area: copy;
          padding-left: 0;
        }
        .install-guide-card--compact summary .guide-control {
          grid-area: control;
          justify-self: end;
        }
        .guide-compact-body p {
          padding: 18px 28px 24px;
        }
      }
      @media (max-width: 640px) {
        .install-guidance-shell {
          width: min(calc(100% - 28px), 1320px);
        }
        .install-guidance-kicker {
          font-size: 10px;
          gap: 8px;
          letter-spacing: 0.16em;
        }
        .install-guidance-header h1 {
          font-size: 40px;
          margin: 14px 0 14px;
        }
        .install-guidance-rule {
          margin-bottom: 18px;
        }
        .install-guidance-header p {
          font-size: 14px;
        }
        .guide-open-layout {
          padding: 22px 18px;
        }
        .guide-open-intro {
          grid-template-columns: 74px 1fr;
          gap: 16px;
          padding-bottom: 18px;
        }
        .guide-icon-circle {
          width: 68px;
          height: 68px;
          font-size: 29px;
        }
        .guide-open-title-wrap h2 {
          font-size: 22px;
          margin: 10px 0 12px;
        }
        .guide-open-title-wrap p {
          font-size: 14px;
          line-height: 1.65;
        }
        .guide-detail-block {
          grid-template-columns: 36px 1fr;
          gap: 12px;
        }
        .guide-detail-icon {
          font-size: 27px;
        }
        .guide-detail-block h3 {
          font-size: 13px;
        }
        .guide-detail-block p {
          font-size: 13px;
          line-height: 1.65;
        }
        .guide-open-image img {
          max-width: none;
          width: 100%;
          height: auto;
          aspect-ratio: 300/230;
        }
        .install-guide-card--compact summary {
          padding: 14px 18px;
          grid-template-columns: 64px 38px 1fr 28px;
          gap: 12px;
        }
        .guide-icon-circle.small {
          width: 56px;
          height: 56px;
          font-size: 22px;
        }
        .guide-step-no {
          font-size: 21px;
        }
        .guide-row-title {
          font-size: 18px;
        }
        .guide-row-copy {
          font-size: 13px;
          line-height: 1.55;
        }
        .install-guidance-note {
          padding: 16px 18px;
          align-items: flex-start;
        }
        .install-guidance-note i {
          width: 38px;
          height: 38px;
          font-size: 18px;
        }
        .install-guidance-note p {
          font-size: 13px;
        }
        .install-infographic-wrap {
          margin-top: 24px;
        }
        .install-infographic-card {
          border-radius: 14px;
        }
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
            ><a href="/shop">Shop</a
            ><a aria-current="page" class="active" href="/installation"
              >Installation</a
            ><a href="/gallery">Gallery</a><a href="/contact">Contact Us</a>
          </nav>
          <a aria-label="Cart" class="cart-link" href="/cart"
            ><i aria-hidden="true" class="fas fa-shopping-cart"></i
            ><span class="badge">0</span></a
          >
        </div>
      </header>
HTML;
$main = <<<'HTML'
<main class="installation-page">
        <section
          class="page-hero installation-hero hero-image-selected"
          style="
            --hero-desktop: url(&quot;/assets/images/hero-selected/installation-service-1920.webp&quot;);
            --hero-tablet: url(&quot;/assets/images/hero-selected/installation-service-1440.webp&quot;);
            --hero-mobile: url(&quot;/assets/images/hero-selected/installation-service-960.webp&quot;);
            --hero-position: center center;
            --hero-position-mobile: 55% center;
          "
        >
          <div class="shell">
            <span class="eyebrow">Installation &amp; care</span>
            <h1>Plan, Install and Care for Your Oven</h1>
            <p>
              Practical guidance for preparing the site, positioning the oven,
              curing it correctly and protecting long-term performance.
            </p>
          </div>
        </section>
        <section
          aria-labelledby="installation-guidance-title"
          class="install-guidance-page"
        >
          <div class="shell install-guidance-shell">
            <header class="install-guidance-header">
              <span class="install-guidance-kicker"
                ><i aria-hidden="true" class="fas fa-fire"></i> Detailed
                Installation Guidance
                <i aria-hidden="true" class="fas fa-fire"></i
              ></span>
              <h2 id="installation-guidance-title">
                Plan, install and care for your oven
              </h2>
              <span aria-hidden="true" class="install-guidance-rule"></span>
              <p>
                Use the expandable guidance below for each stage of your
                project.<br />Product-specific instructions supplied with your
                oven always take priority.
              </p>
            </header>
            <div class="install-guide-list">
              <details
                class="install-guide-card install-guide-card--open"
                open=""
              >
                <summary aria-label="Toggle Planning and preparation section">
                  <span aria-hidden="true" class="guide-control"
                    ><i class="fas fa-minus"></i
                  ></span>
                </summary>
                <div class="guide-open-layout">
                  <div class="guide-open-intro">
                    <div class="guide-icon-circle">
                      <i aria-hidden="true" class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="guide-open-title-wrap">
                      <span class="guide-step-no">01</span>
                      <h2>Planning and preparation</h2>
                      <p>
                        Confirm the site, supporting structure and access before
                        delivery day.
                      </p>
                    </div>
                  </div>
                  <div class="guide-open-details">
                    <article class="guide-detail-block">
                      <div class="guide-detail-icon">
                        <i aria-hidden="true" class="fas fa-ruler-combined"></i>
                      </div>
                      <div>
                        <h3>Site assessment and clearances</h3>
                        <p>
                          Measure the installation area, check overhead and side
                          clearances, confirm ventilation and keep combustible
                          materials away from the oven. Review weather exposure
                          and prevailing wind direction before choosing the
                          final position.
                        </p>
                      </div>
                    </article>
                    <article class="guide-detail-block">
                      <div class="guide-detail-icon">
                        <i aria-hidden="true" class="fas fa-border-all"></i>
                      </div>
                      <div>
                        <h3>Base construction and load support</h3>
                        <p>
                          Ensure a level, stable and non-combustible base that
                          can properly support the oven's weight. Allow adequate
                          curing time before installation.
                        </p>
                      </div>
                    </article>
                  </div>
                  <div class="guide-open-image">
                    <img
                      alt="Outdoor mosaic pizza oven installed on a prepared masonry base"
                      decoding="async"
                      loading="lazy"
                      sizes="(max-width: 900px) 100vw, 50vw"
                      src="assets/images/optimized/installation-residential-real-1200.webp"
                      srcset="
                        assets/images/optimized/installation-residential-real-480.webp   480w,
                        assets/images/optimized/installation-residential-real-640.webp   640w,
                        assets/images/optimized/installation-residential-real-960.webp   960w,
                        assets/images/optimized/installation-residential-real-1200.webp 1200w,
                        assets/images/optimized/installation-residential-real-1440.webp 1440w,
                        assets/images/optimized/installation-residential-real-1800.webp 1800w
                      "
                    />
                  </div>
                </div>
              </details>
              <details class="install-guide-card install-guide-card--compact">
                <summary>
                  <span class="guide-row-icon"
                    ><span class="guide-icon-circle small"
                      ><i
                        aria-hidden="true"
                        class="fas fa-truck-fast"
                      ></i></span
                  ></span>
                  <span class="guide-step-no">02</span>
                  <span class="guide-row-title">Delivery and positioning</span>
                  <span class="guide-row-copy"
                    >Prepare a safe route and use enough lifting
                    assistance.</span
                  >
                  <span aria-hidden="true" class="guide-control"
                    ><i class="fas fa-plus"></i
                  ></span>
                </summary>
                <div class="guide-compact-body">
                  <p>
                    Prepare access routes before delivery, protect surrounding
                    finishes and ensure adequate lifting assistance is
                    available. Position the oven carefully on the prepared base
                    and confirm that it is centred and stable before use.
                  </p>
                </div>
              </details>
              <details class="install-guide-card install-guide-card--compact">
                <summary>
                  <span class="guide-row-icon"
                    ><span class="guide-icon-circle small"
                      ><i
                        aria-hidden="true"
                        class="fas fa-fire-flame-curved"
                      ></i></span
                  ></span>
                  <span class="guide-step-no">03</span>
                  <span class="guide-row-title">Curing and first use</span>
                  <span class="guide-row-copy"
                    >Introduce heat gradually so trapped moisture can escape
                    safely.</span
                  >
                  <span aria-hidden="true" class="guide-control"
                    ><i class="fas fa-plus"></i
                  ></span>
                </summary>
                <div class="guide-compact-body">
                  <p>
                    Build small fires first and increase the temperature
                    progressively over several sessions. A gradual curing
                    process helps residual moisture escape safely and supports
                    the long-term durability of the oven structure.
                  </p>
                </div>
              </details>
              <details class="install-guide-card install-guide-card--compact">
                <summary>
                  <span class="guide-row-icon"
                    ><span class="guide-icon-circle small"
                      ><i aria-hidden="true" class="fas fa-broom"></i></span
                  ></span>
                  <span class="guide-step-no">04</span>
                  <span class="guide-row-title">Ongoing care</span>
                  <span class="guide-row-copy"
                    >Simple routine checks help protect performance and
                    appearance.</span
                  >
                  <span aria-hidden="true" class="guide-control"
                    ><i class="fas fa-plus"></i
                  ></span>
                </summary>
                <div class="guide-compact-body">
                  <p>
                    Clean out cooled ash regularly, protect the oven from
                    prolonged moisture and inspect the finish from time to time.
                    Prompt touch-ups and routine checks help preserve
                    performance, safety and appearance.
                  </p>
                </div>
              </details>
            </div>
            <div class="install-guidance-note">
              <i aria-hidden="true" class="fas fa-circle-info"></i>
              <p>
                <strong>Important:</strong> Product-specific instructions
                supplied with your oven always take priority.
              </p>
            </div>
            <section
              aria-labelledby="installation-summary-title"
              class="install-guide-summary"
            >
              <header>
                <span class="install-guidance-kicker"
                  ><i aria-hidden="true" class="fas fa-fire"></i> Installation
                  and maintenance guide
                  <i aria-hidden="true" class="fas fa-fire"></i
                ></span>
                <h3 id="installation-summary-title">
                  Installation made simple
                </h3>
                <p>
                  DIY pizza ovens arrive as a single, fully assembled unit.
                  Follow the supplied product instructions and use this overview
                  to prepare the base, position the oven, complete the finish,
                  cure it gradually and maintain it.
                </p>
              </header>
              <div class="install-guide-summary-grid">
                <article>
                  <h4>Prepare the base</h4>
                  <p>
                    Mix the supplied insulation under-base material with water
                    to a workable consistency. Spread it evenly, creating a
                    thickness of 20 mm at the back and 15 mm at the front to
                    form a slight downward angle.
                  </p>
                </article>
                <article>
                  <h4>Place and finish</h4>
                  <p>
                    Position the oven securely on the prepared stand, then
                    complete the surrounding grout or finish in accordance with
                    the product-specific installation instructions.
                  </p>
                </article>
                <article>
                  <h4>Five-day curing procedure</h4>
                  <ul>
                    <li>Day 1: Heat to 65°C for 2–3 hours.</li>
                    <li>Day 2: Increase to 100°C for 2–3 hours.</li>
                    <li>Day 3: Heat to 150°C for 2–3 hours.</li>
                    <li>Day 4: Raise to 210°C for 2–3 hours.</li>
                    <li>Day 5: Finish at 250°C for 2–3 hours.</li>
                  </ul>
                </article>
                <article id="maintenance">
                  <h4>Maintenance tips</h4>
                  <ul>
                    <li>Keep the oven below 250°C for optimal performance.</li>
                    <li>
                      Avoid soaking the interior and keep the door closed during
                      wet weather.
                    </li>
                    <li>
                      Hairline cracks are normal; fill larger cracks with
                      suitable mortar if required.
                    </li>
                    <li>
                      Use seasoned wood to minimise smoke and touch up the
                      exterior when needed.
                    </li>
                  </ul>
                </article>
                <article class="stand-sizes">
                  <div><h4>Recommended DIY oven stand sizes</h4></div>
                  <span><strong>Small</strong>1.0 m × 1.0 m × 1.1 m high</span
                  ><span><strong>Medium</strong>1.1 m × 1.1 m × 1.1 m high</span
                  ><span><strong>Large</strong>1.2 m × 1.2 m × 1.1 m high</span>
                </article>
              </div>
              <p class="summary-note">
                Dimensions are approximate. Ensure that the oven stand is level,
                stable and appropriate for the selected product.
              </p>
            </section>
          </div>
        </section>
        <section
          class="installation-facts-section fd-force-dark"
          aria-labelledby="installation-facts-title"
        >
          <div class="installation-facts-shell">
            <header class="installation-facts-header">
              <span class="eyebrow">DIY installation guide</span>
              <h2 id="installation-facts-title">
                Five Clear Steps From Base to First Fire
              </h2>
              <p>
                DIY ovens arrive as fully assembled units. Use this full-width
                overview to prepare the site, position the oven, complete the
                finish and cure it correctly before regular cooking.
              </p>
            </header>
            <ol class="installation-facts-grid">
              <li>
                <span class="installation-facts-number">01</span
                ><i aria-hidden="true" class="fas fa-layer-group"></i>
                <h3>Prepare the base</h3>
                <p>
                  Use a stable, level, non-combustible supporting structure
                  sized for the selected oven.
                </p>
              </li>
              <li>
                <span class="installation-facts-number">02</span
                ><i aria-hidden="true" class="fas fa-truck-loading"></i>
                <h3>Place the oven</h3>
                <p>
                  Plan the access route and use suitable lifting assistance to
                  centre the oven securely.
                </p>
              </li>
              <li>
                <span class="installation-facts-number">03</span
                ><i aria-hidden="true" class="fas fa-hammer"></i>
                <h3>Finish carefully</h3>
                <p>
                  Complete compatible grout or surrounding finishes as specified
                  for the product.
                </p>
              </li>
              <li>
                <span class="installation-facts-number">04</span
                ><i aria-hidden="true" class="fas fa-fire"></i>
                <h3>Cure gradually</h3>
                <p>
                  Build small fires and increase temperature progressively over
                  the five-day curing schedule.
                </p>
              </li>
              <li>
                <span class="installation-facts-number">05</span
                ><i aria-hidden="true" class="fas fa-tools"></i>
                <h3>Maintain routinely</h3>
                <p>
                  Remove cooled ash, protect the oven from moisture and inspect
                  finishes over time.
                </p>
              </li>
            </ol>
            <aside class="installation-facts-note">
              <i aria-hidden="true" class="fas fa-info-circle"></i>
              <p>
                <strong>Always follow product instructions:</strong> specific
                requirements supplied with your selected oven take priority over
                this general planning guide.
              </p>
            </aside>
          </div>
        </section>
        <section class="section fd-alt-white" data-kt-integrated="true">
          <div class="shell">
            <header class="section-head">
              <span class="eyebrow">Recommended stand sizes</span>
              <h2>Allow the Right Footprint</h2>
            </header>
            <div class="fact-grid three">
              <article>
                <strong>Small</strong><span>1.0 m × 1.0 m × 1.1 m high</span>
              </article>
              <article>
                <strong>Medium</strong><span>1.1 m × 1.1 m × 1.1 m high</span>
              </article>
              <article>
                <strong>Large</strong><span>1.2 m × 1.3 m × 1.1 m high</span>
              </article>
            </div>
            <div class="supporting-note">
              <p>
                Delivery and installation are quoted separately. Customer
                support is available for curing, operation and flue-installation
                guidance.
              </p>
            </div>
          </div>
        </section>
        <section
          class="cta site-final-cta"
          style="
            background-image:
              linear-gradient(rgba(5, 6, 6, 0.78), rgba(5, 6, 6, 0.92)),
              url(&quot;assets/images/fire-and-dine/cta/cta-04-book-installation.webp&quot;);
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
<script>
      document.addEventListener("DOMContentLoaded", function () {
        const group = document.querySelector(".install-guide-list");
        if (!group) return;
        const items = Array.from(group.querySelectorAll("details"));
        items.forEach((item) => {
          item.addEventListener("toggle", () => {
            if (item.open) {
              items.forEach((other) => {
                if (other !== item) other.open = false;
              });
            }
          });
        });
      });
    </script>
    <script src="assets/js/fire-dine-premium.js"></script>
    <script src="/assets/js/x3-tracking.js"></script>
    <script src="/assets/js/brochure-widget.js"></script>
  
HTML;
require dirname(__DIR__) . '/layouts/app.php';
