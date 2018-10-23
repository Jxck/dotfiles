function format(date) {
  const day    = date.getDate()     .toString().padStart(2, 0)
  const month  = (date.getMonth()+1).toString().padStart(2, 0)
  const year   = date.getFullYear() .toString().padStart(2, 0)
  const hour   = date.getHours()    .toString().padStart(2, 0)
  const minute = date.getMinutes()  .toString().padStart(2, 0)
  const second = date.getSeconds()  .toString().padStart(2, 0)
  const offset = date.getTimezoneOffset()
  const sign   = offset > 0 ? "+" : "-"
  const zone   = Math.abs(offset/60).toString().padStart(2, 0).padEnd(4, 0)

  //[day/month/year:hour:minute:second zone]
  return `[${month}/${day}/${year}:${hour}:${minute}:${second} ${sign}${zone}]`
}

console.log(format(new Date())); // "[02/Aug/2013:22:19:08 -0540]"
