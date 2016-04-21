javascript: (function() {
let url = new URL(document.getElementsByClassName('slide_image')[0].currentSrc);
let path = url.pathname.split('/');
let last = path.pop().split('-');
path = path.join('/');

function prefetch(n) {
  const para = 5;
  Promise.all(Array.from(Array(para).keys())
    .map((i) => i+para*(n-1))
    .map((i) => {
      last[1] = i;
      url.pathname = path + '/' + last.join('-');
      console.log(url.toString());
      return fetch(url, {mode:'no-cors'});
    })
  ).then(() => {
    return prefetch(n+1);
  });
}
prefetch(1);
})();
