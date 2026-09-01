(function() {
  'use strict';

  const slider = document.getElementById('slider');
  const slides = document.getElementById('slides');
  const dotsContainer = document.getElementById('dots');
  const totalSlides = slides.children.length;
  let current = 0;
  let autoplayTimer = null;
  let isDragging = false;
  let startX = 0;
  let currentTranslate = 0;
  let prevTranslate = 0;
  let animationID;

  const config = {
    autoplay: { delay: 2500, disableOnInteraction: false },
    speed: 600,
    loop: true,
    effect: 'slide',
    grabCursor: true,
    keyboard: true,
    mousewheel: true,
    pagination: { clickable: true },
    navigation: true,
    spaceBetween: 0,
    slidesPerView: 1,
    centeredSlides: false,
    fadeEffect: { crossFade: false },
    cubeEffect: { shadow: true, slideShadows: true },
    coverflowEffect: { rotate: 50, stretch: 0, depth: 100, modifier: 1, slideShadows: true },
    flipEffect: { slideShadows: true, limitRotation: true },
    a11y: { enabled: true }
  };

  if (config.grabCursor) {
    slides.style.cursor = 'grab';
  }

  const prevBtn = document.createElement('button');
  prevBtn.className = 'slider-nav slider-prev';
  prevBtn.innerHTML = '‹';
  prevBtn.setAttribute('aria-label', 'Previous slide');
  prevBtn.addEventListener('click', () => prev());

  const nextBtn = document.createElement('button');
  nextBtn.className = 'slider-nav slider-next';
  nextBtn.innerHTML = '›';
  nextBtn.setAttribute('aria-label', 'Next slide');
  nextBtn.addEventListener('click', () => next());

  if (config.navigation) {
    slider.appendChild(prevBtn);
    slider.appendChild(nextBtn);
  }

  const style = document.createElement('style');
  style.textContent = `
    .slider-nav {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      background: rgba(2, 58, 107, 0.7);
      color: #fff;
      border: none;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      font-size: 24px;
      cursor: pointer;
      z-index: 10;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.3s;
    }
    .slider-nav:hover { background: rgba(2, 58, 107, 0.9); }
    .slider-prev { left: 10px; }
    .slider-next { right: 10px; }
  `;
  document.head.appendChild(style);

  if (config.pagination) {
    for (let i = 0; i < totalSlides; i++) {
      const dot = document.createElement('div');
      dot.className = 'dot' + (i === 0 ? ' active' : '');
      dot.setAttribute('role', 'button');
      dot.setAttribute('tabindex', '0');
      dot.setAttribute('aria-label', 'Go to slide ' + (i + 1));
      if (config.pagination.clickable) {
        dot.addEventListener('click', () => goTo(i));
        dot.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') goTo(i); });
      }
      dotsContainer.appendChild(dot);
    }
  }

  const dots = dotsContainer.children;

  function setSliderPosition() {
    slides.style.transform = 'translateX(-' + (current * 100) + '%)';
  }

  function goTo(index) {
    prevTranslate = -index * slides.clientWidth;
    currentTranslate = prevTranslate;
    current = index;

    if (config.loop) {
      if (current >= totalSlides) current = 0;
      if (current < 0) current = totalSlides - 1;
    } else {
      current = Math.max(0, Math.min(current, totalSlides - 1));
    }

    setSliderPosition();

    for (let i = 0; i < dots.length; i++) {
      dots[i].className = 'dot' + (i === current ? ' active' : '');
      dots[i].setAttribute('aria-current', i === current ? 'true' : 'false');
    }

    if (!config.autoplay.disableOnInteraction) {
      resetAutoplay();
    }
  }

  function next() {
    goTo(current + 1);
  }

  function prev() {
    goTo(current - 1);
  }

  function startAutoplay() {
    if (config.autoplay && config.autoplay.delay) {
      autoplayTimer = setInterval(next, config.autoplay.delay);
    }
  }

  function stopAutoplay() {
    if (autoplayTimer) {
      clearInterval(autoplayTimer);
      autoplayTimer = null;
    }
  }

  function resetAutoplay() {
    stopAutoplay();
    startAutoplay();
  }

  if (config.autoplay && config.autoplay.delay) {
    startAutoplay();
    slider.addEventListener('mouseenter', stopAutoplay);
    slider.addEventListener('mouseleave', startAutoplay);
    slider.addEventListener('touchstart', stopAutoplay, { passive: true });
    slider.addEventListener('touchend', startAutoplay);
  }

  slides.addEventListener('mousedown', touchStart);
  slides.addEventListener('touchstart', touchStart, { passive: true });
  slides.addEventListener('mouseup', touchEnd);
  slides.addEventListener('mouseleave', () => { if (isDragging) touchEnd(); });
  slides.addEventListener('touchend', touchEnd);
  slides.addEventListener('mousemove', touchMove);

  function touchStart(event) {
    isDragging = true;
    startX = getPositionX(event);
    animationID = requestAnimationFrame(animation);
    if (config.grabCursor) slides.style.cursor = 'grabbing';
  }

  function touchEnd() {
    isDragging = false;
    cancelAnimationFrame(animationID);
    if (config.grabCursor) slides.style.cursor = 'grab';

    const movedBy = currentTranslate - prevTranslate;
    const threshold = slides.clientWidth * 0.2;

    if (movedBy < -threshold) next();
    else if (movedBy > threshold) prev();
    else goTo(current);
  }

  function touchMove(event) {
    if (isDragging) {
      const currentPosition = getPositionX(event);
      currentTranslate = prevTranslate + currentPosition - startX;
    }
  }

  function getPositionX(event) {
    return event.type.includes('mouse') ? event.pageX : event.touches[0].clientX;
  }

  function animation() {
    setSliderPosition();
    if (isDragging) requestAnimationFrame(animation);
  }

  if (config.keyboard) {
    document.addEventListener('keydown', (e) => {
      if (e.key === 'ArrowLeft') prev();
      if (e.key === 'ArrowRight') next();
    });
  }

  if (config.mousewheel) {
    slider.addEventListener('wheel', (e) => {
      e.preventDefault();
      if (e.deltaY > 0) next();
      else if (e.deltaY < 0) prev();
    }, { passive: false });
  }

  setSliderPosition();
})();
