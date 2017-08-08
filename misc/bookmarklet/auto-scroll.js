javascript:(() => {
  let interval = null;
  let time = 30;
  let len = 1;
  window.addEventListener('click', () => {
    if (interval === null) {
      interval = setInterval(() => {
        scrollBy(0, len);
      }, time);
    } else {
      clearInterval(interval);
      interval = null;
    }
  });
  window.addEventListener('keyup', (e) => {
    console.log(e.key);
    if (e.key.toString().endsWith('Down')) {
      len *= 1.1;
    }
    if (e.key.toString().endsWith('Up')) {
      len /= 1.1;
    }
    console.log(len);
  });
})();
