(function(date) {
  var zeroPadding = function(n, len) {
    n = n.toString();
    var l = n.length;
    if (l < len) {
      return '0' + zeroPadding(n, len - 1);
    }
    return n;
  };

  var MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var d = date.getDate(),
      m = MONTHS[date.getMonth()],
      y = date.getFullYear(),
      h = date.getHours(),
      mi = date.getMinutes(),
      s = date.getSeconds(),
      z = date.getTimezoneOffset().toString();

  var sign = z.charAt(0);
      z = z.substr(1);

  var day = zeroPadding(d, 2),
      month = m,
      year = y,
      hour = zeroPadding(h, 2),
      minute = zeroPadding(mi, 2),
      second = zeroPadding(s, 2),
      zone = zeroPadding(z, 4);

  //[day/month/year:hour:minute:second zone]
  return '[' + day + '/' + month + '/' + year + ':' + hour + ':' + minute + ':' + second + ' ' + sign + zone + ']';
})(new Date()); // "[02/Aug/2013:22:19:08 -0540]"
