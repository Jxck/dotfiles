#!/usr/bin/env osascript -l JavaScript

function run(arg) {
  console.log("run with", arg)

  let browser = ''
  switch(arg) {
    case 'chrome':
      browser = 'Google Chrome'
    case 'edge':
      browser = "Microsoft Edge"
    default:
      browser = 'Google Chrome'
  }

  Application(browser).windows().forEach((window) => {
    window.tabs().forEach((tab) => {
      const url  = tab.url()
      const name = tab.name()
      console.log(name + "\r\n\t" + url)
    })
  })
}

