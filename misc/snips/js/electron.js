'use strict';

let app = require('app');
let BrowserWindow = require('browser-window');

require('crash-reporter').start();

let window = null;

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('ready', () => {
  window = new BrowserWindow({
    width: 10000,
    height: 10000,
  });
  window.openDevTools();
  window.loadUrl(`file://${__dirname}/index.html`);

  window.on('closed', () => {
    window = null;
  });
});
