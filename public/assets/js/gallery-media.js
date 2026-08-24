(() => {
  'use strict';

  const images = [...document.querySelectorAll('.x3-gallery-image')];
  const imageDialog = document.querySelector('.x3-gallery-lightbox');
  let imageIndex = 0;
  let lastFocus = null;

  const showImage = (index) => {
    if (!imageDialog || !images.length) return;
    imageIndex = (index + images.length) % images.length;
    const link = images[imageIndex];
    const image = imageDialog.querySelector('img');
    image.src = link.href;
    image.alt = link.querySelector('img')?.alt || '';
    imageDialog.querySelector('figcaption').textContent = link.dataset.title || '';
    lastFocus = document.activeElement;
    if (!imageDialog.open) imageDialog.showModal();
    imageDialog.querySelector('.x3-lightbox-close').focus();
  };

  images.forEach((link, index) => link.addEventListener('click', (event) => {
    event.preventDefault();
    showImage(index);
  }));
  imageDialog?.querySelector('.x3-lightbox-close')?.addEventListener('click', () => imageDialog.close());
  imageDialog?.querySelector('.x3-lightbox-prev')?.addEventListener('click', () => showImage(imageIndex - 1));
  imageDialog?.querySelector('.x3-lightbox-next')?.addEventListener('click', () => showImage(imageIndex + 1));
  imageDialog?.addEventListener('close', () => lastFocus?.focus());
  imageDialog?.addEventListener('click', (event) => { if (event.target === imageDialog) imageDialog.close(); });
  document.addEventListener('keydown', (event) => {
    if (!imageDialog?.open) return;
    if (event.key === 'ArrowLeft') showImage(imageIndex - 1);
    if (event.key === 'ArrowRight') showImage(imageIndex + 1);
  });

  const track = (name, element) => globalThis.X3Tracking?.track(name, {
    video_id: element.dataset.videoId,
    video_title: element.dataset.videoTitle,
    location: 'gallery'
  });

  document.querySelectorAll('.x3-video-card video').forEach((video) => {
    let started = false;
    let completed = false;
    video.addEventListener('play', () => {
      if (!started) {
        started = true;
        track('video_start', video);
      }
    });
    video.addEventListener('ended', () => {
      if (!completed) {
        completed = true;
        track('video_complete', video);
      }
    });
  });

  const videoDialog = document.querySelector('.x3-video-lightbox');
  const player = videoDialog?.querySelector('.x3-video-lightbox-player');
  const videoTitle = videoDialog?.querySelector('.x3-video-lightbox-copy h2');
  const videoDescription = videoDialog?.querySelector('.x3-video-lightbox-copy p');
  let videoTrigger = null;

  document.querySelectorAll('.x3-external-video').forEach((link) => link.addEventListener('click', (event) => {
    if (!videoDialog || !player) return;
    event.preventDefault();
    videoTrigger = link;
    const iframe = document.createElement('iframe');
    iframe.src = link.dataset.provider === 'youtube'
      ? `https://www.youtube-nocookie.com/embed/${link.dataset.externalId}?autoplay=1`
      : `https://player.vimeo.com/video/${link.dataset.externalId}?autoplay=1`;
    iframe.title = link.dataset.videoTitle || 'Gallery video';
    iframe.allow = 'autoplay; fullscreen; picture-in-picture';
    iframe.allowFullscreen = true;
    player.replaceChildren(iframe);
    if (videoTitle) videoTitle.textContent = link.dataset.videoTitle || '';
    if (videoDescription) {
      videoDescription.textContent = link.dataset.videoDescription || '';
      videoDescription.hidden = !link.dataset.videoDescription;
    }
    track('video_start', link);
    videoDialog.showModal();
    videoDialog.querySelector('.x3-video-close').focus();
  }));

  videoDialog?.querySelector('.x3-video-close')?.addEventListener('click', () => videoDialog.close());
  videoDialog?.addEventListener('close', () => {
    player?.replaceChildren();
    videoTrigger?.focus();
  });
  videoDialog?.addEventListener('click', (event) => { if (event.target === videoDialog) videoDialog.close(); });
})();
