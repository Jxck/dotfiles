#!/usr/bin/env osascript -l JavaScript

function run(arg) {
  arg = arg.toString()
  let browser = ''
  switch(arg) {
    case 'chrome':
      browser = 'Google Chrome'
      break;
    case 'edge':
      browser = "Microsoft Edge"
      break;
    default:
      browser = 'Google Chrome'
      break;
  }

  Application(browser).windows().forEach((window) => {
    console.log('\n\n')
    window.tabs().forEach((tab) => {
      const url  = tab.url()
      const name = tab.name()
      console.log(`- ${name}`)
      console.log(`- ${url}`)
    })
  })
}

