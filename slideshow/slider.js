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

  const effects = ['slide', 'fade', 'cube', 'coverflow', 'flip', 'cards', 'creative'];

  const defaultEffect = (() => {
    const params = new URLSearchParams(window.location.search);
    const e = params.get('effect');
    return effects.includes(e) ? e : 'slide';
  })();

  const config = {
    autoplay: { delay: 2500, disableOnInteraction: false },
    speed: 600,
    loop: true,
    effect: defaultEffect,
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
    coverflowEffect: { rotate: 30, stretch: 0, depth: 100, modifier: 1, slideShadows: true },
    flipEffect: { slideShadows: true, limitRotation: true },
    a11y: { enabled: true }
  };

  function applyEffectClasses() {
    slides.className = 'slides';
    slides.style.transform = '';
    slides.style.transformStyle = '';
    slides.style.perspective = '';
    slider.style.overflow = 'hidden';
    const slideEls = slides.children;
    for (let i = 0; i < slideEls.length; i++) {
      slideEls[i].style.transform = '';
      slideEls[i].style.opacity = '';
      slideEls[i].style.backfaceVisibility = '';
      slideEls[i].style.transformStyle = '';
      slideEls[i].style.zIndex = '';
      slideEls[i].style.boxShadow = '';
    }

    switch (config.effect) {
      case 'fade':
        slides.style.transition = 'opacity ' + config.speed + 'ms';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.opacity = i === current ? '1' : '0';
          slideEls[i].style.transition = 'opacity ' + config.speed + 'ms';
          slideEls[i].style.zIndex = i === current ? '1' : '0';
        }
        break;

      case 'cube':
        slides.style.transformStyle = 'preserve-3d';
        slides.style.transform = 'translateZ(-' + (window.innerHeight / 2) + 'px) rotateY(0deg)';
        slides.style.transition = 'transform ' + config.speed + 'ms';
        slider.style.perspective = '1200px';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.backfaceVisibility = 'hidden';
          slideEls[i].style.transformStyle = 'preserve-3d';
          const angle = i * -90;
          slideEls[i].style.transform = 'rotateY(' + angle + 'deg) translateZ(' + (window.innerWidth / 2) + 'px)';
        }
        break;

      case 'coverflow':
        slides.style.transformStyle = 'preserve-3d';
        slides.style.transition = 'transform ' + config.speed + 'ms';
        slider.style.perspective = '1200px';
        slider.style.overflow = 'visible';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.transition = 'transform ' + config.speed + 'ms, opacity ' + config.speed + 'ms';
        }
        break;

      case 'flip':
        slides.style.transformStyle = 'preserve-3d';
        slides.style.transition = 'transform ' + config.speed + 'ms';
        slider.style.perspective = '1200px';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.backfaceVisibility = 'hidden';
          slideEls[i].style.transformStyle = 'preserve-3d';
          const angle = i * -180;
          slideEls[i].style.transform = 'rotateY(' + angle + 'deg)';
        }
        break;

      case 'cards':
        slides.style.transformStyle = 'preserve-3d';
        slides.style.transition = 'transform ' + config.speed + 'ms';
        slider.style.perspective = '1200px';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.transition = 'transform ' + config.speed + 'ms, opacity ' + config.speed + 'ms';
          slideEls[i].style.backfaceVisibility = 'hidden';
        }
        break;

      case 'creative':
        slides.style.transition = 'transform ' + config.speed + 'ms';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = 'absolute';
          slideEls[i].style.top = '0';
          slideEls[i].style.left = '0';
          slideEls[i].style.transition = 'transform ' + config.speed + 'ms, opacity ' + config.speed + 'ms, clip-path ' + config.speed + 'ms';
        }
        break;

      default:
        slides.style.transition = 'transform ' + config.speed + 'ms cubic-bezier(0.25, 0.46, 0.45, 0.94)';
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.position = '';
          slideEls[i].style.top = '';
          slideEls[i].style.left = '';
        }
    }
  }

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

  const effectLabels = {
    slide: 'Slide',
    fade: 'Fade',
    cube: 'Cube',
    coverflow: 'Coverflow',
    flip: 'Flip',
    cards: 'Cards',
    creative: 'Creative'
  };

  const effectSelector = document.createElement('div');
  effectSelector.className = 'effect-selector';
  effects.forEach(eff => {
    const btn = document.createElement('button');
    btn.className = 'effect-btn' + (eff === config.effect ? ' active' : '');
    btn.textContent = effectLabels[eff];
    btn.setAttribute('aria-label', 'Apply ' + effectLabels[eff] + ' effect');
    btn.addEventListener('click', () => {
      config.effect = eff;
      applyEffectClasses();
      goTo(current);
      const allBtns = effectSelector.querySelectorAll('.effect-btn');
      allBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
    });
    effectSelector.appendChild(btn);
  });
  slider.appendChild(effectSelector);

  const style = document.createElement('style');
  style.textContent = `
    .slider-nav {
      display: none !important;
    }
    .slider-nav:hover { background: rgba(2, 58, 107, 0.9); }
    .slider-prev { left: 10px; }
    .slider-next { right: 10px; }
    .effect-selector {
      display: none;
    }
    .effect-btn {
      background: transparent;
      color: rgba(255,255,255,0.7);
      border: 1px solid rgba(255,255,255,0.3);
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 11px;
      cursor: pointer;
      transition: all 0.2s;
      white-space: nowrap;
    }
    .effect-btn:hover { background: rgba(255,255,255,0.15); color: #fff; }
    .effect-btn.active {
      background: #35d852;
      color: #fff;
      border-color: #35d852;
    }
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
    const slideEls = slides.children;
    switch (config.effect) {
      case 'fade':
        for (let i = 0; i < slideEls.length; i++) {
          slideEls[i].style.opacity = i === current ? '1' : '0';
          slideEls[i].style.zIndex = i === current ? '1' : '0';
        }
        break;

      case 'cube':
        slides.style.transform = 'translateZ(-' + (window.innerHeight / 2) + 'px) rotateY(' + (current * 90) + 'deg)';
        break;

      case 'coverflow': {
        const rotate = config.coverflowEffect.rotate;
        const depth = config.coverflowEffect.depth;
        for (let i = 0; i < slideEls.length; i++) {
          const offset = i - current;
          const absOffset = Math.abs(offset);
          slideEls[i].style.transform = 'translateX(' + (offset * window.innerWidth * 0.6) + 'px) translateZ(-' + (absOffset * depth) + 'px) rotateY(' + (-offset * rotate) + 'deg)';
          slideEls[i].style.opacity = absOffset > 2 ? '0' : '1';
        }
        break;
      }

      case 'flip':
        slides.style.transform = 'rotateY(' + (current * 180) + 'deg)';
        break;

      case 'cards':
        for (let i = 0; i < slideEls.length; i++) {
          const offset = i - current;
          slideEls[i].style.transform = 'translateX(' + (offset * 40) + 'px) translateZ(-' + (Math.abs(offset) * 100) + 'px) scale(' + (1 - Math.abs(offset) * 0.1) + ')';
          slideEls[i].style.zIndex = totalSlides - Math.abs(offset);
          slideEls[i].style.opacity = Math.abs(offset) > 3 ? '0' : '1';
        }
        break;

      case 'creative':
        for (let i = 0; i < slideEls.length; i++) {
          const offset = i - current;
          if (offset === 0) {
            slideEls[i].style.transform = 'scale(1) translateX(0)';
            slideEls[i].style.opacity = '1';
            slideEls[i].style.clipPath = 'inset(0 0 0 0)';
            slideEls[i].style.zIndex = '2';
          } else if (offset < 0) {
            slideEls[i].style.transform = 'scale(0.8) translateX(-30%)';
            slideEls[i].style.opacity = '0.5';
            slideEls[i].style.clipPath = 'inset(0 100% 0 0)';
            slideEls[i].style.zIndex = '0';
          } else {
            slideEls[i].style.transform = 'scale(0.8) translateX(30%)';
            slideEls[i].style.opacity = '0.5';
            slideEls[i].style.clipPath = 'inset(0 0 0 100%)';
            slideEls[i].style.zIndex = '0';
          }
        }
        break;

      default:
        slides.style.transform = 'translateX(-' + (current * window.innerWidth) + 'px)';
    }
  }

  function goTo(index) {
    prevTranslate = -index * window.innerWidth;
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
    const threshold = window.innerWidth * 0.2;

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

  window.addEventListener('resize', () => {
    applyEffectClasses();
    setSliderPosition();
  });

  applyEffectClasses();
  setSliderPosition();
})();
