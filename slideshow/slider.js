(function() {
  const slides = document.getElementById('slides');
  const dotsContainer = document.getElementById('dots');
  const totalSlides = slides.children.length;
  let current = 0;
  let autoplayInterval;

  for (let i = 0; i < totalSlides; i++) {
    const dot = document.createElement('div');
    dot.className = 'dot' + (i === 0 ? ' active' : '');
    dot.addEventListener('click', () => goTo(i));
    dotsContainer.appendChild(dot);
  }

  const dots = dotsContainer.children;

  function goTo(index) {
    current = index;
    slides.style.transform = 'translateX(-' + (current * 100) + '%)';
    for (let i = 0; i < dots.length; i++) {
      dots[i].className = 'dot' + (i === current ? ' active' : '');
    }
  }

  function next() {
    goTo((current + 1) % totalSlides);
  }

  function startAutoplay() {
    autoplayInterval = setInterval(next, 2500);
  }

  function stopAutoplay() {
    clearInterval(autoplayInterval);
  }

  const slider = document.getElementById('slider');
  slider.addEventListener('mouseenter', stopAutoplay);
  slider.addEventListener('mouseleave', startAutoplay);
  slider.addEventListener('touchstart', stopAutoplay);
  slider.addEventListener('touchend', startAutoplay);

  startAutoplay();
})();
