var url = location.origin;
Array.prototype.slice.call(document.querySelectorAll('h1, h2, h3, h4')).forEach(function($h) {
  var $a = document.createElement('a');
  $a.textContent = $h.textContent;
  $h.textContent = '';
  $a.href = url + '#' + $h.id;
  $a.style.color = getComputedStyle($h).color;
  $h.appendChild($a);
});
