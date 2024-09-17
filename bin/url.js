#!/usr/bin/env osascript -l JavaScript

function run(arg) {
  arg = arg.toString()
  let browser = ''
  switch(arg) {
    case 'chrome':
      browser = 'Google Chrome'
      break;
    case 'edge':
      // browser = "Microsoft Edge Canary"
      browser = "Microsoft Edge"
      break;
    default:
      browser = 'Google Chrome'
      break;
  }

  Application(browser).windows().forEach((window) => {
    console.log('\n\n')
    const map = window.tabs().map((tab) => {
      const name = tab.name()
      const url  = (() => {
        if (tab.url().startsWith("https://groups.google.com/a/chromium.org")) {
          return tab.url().replace(/\/m\/.*/, "")
        }
        return tab.url()
      })()
      return {url, name}
    }).reduce((map, {url, name}) => {
      if (
        url.startsWith("https://jp.inoreader.com/") ||
        url.startsWith("https://www.inoreader.com/")
      ) {
        return map
      }
      map.set(url, name)
      return map
    }, new Map());

    Array.from(map.entries()).sort((a, b) => {
      return a.at(1) > b.at(1)
    })
    .forEach(([url, name]) => {
      console.log(`${name}\t${url}`)
    })
  })
}

