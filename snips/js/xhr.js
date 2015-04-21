var xhr = new XMLHttpRequest();
xhr.open('POST', '/subscription');
// xhr.setRequestHeader();
xhr.responseType = 'json';
xhr.addEventListener('load', function() {
  console.log(xhr.response);
});
xhr.send('test');
