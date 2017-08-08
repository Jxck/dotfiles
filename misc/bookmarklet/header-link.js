javascript: (() => {
  /** make header to link **/
  let url = new URL(location.href);
  for (let $h of document.querySelectorAll('h1, h2, h3, h4')) {
    let $a = document.createElement('a');
    $a.textContent = $h.textContent;
    $h.textContent = '';
    url.hash = $h.id;
    $a.href = url.toString();
    $a.style.color = getComputedStyle($h).color;
    $h.appendChild($a);
  };
})();
