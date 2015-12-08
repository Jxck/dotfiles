#!/usr/bin/env node

let fs = require('fs');
let spawn = require('child_process').spawn;

let file = '/tmp/ws-broadcast.log';

process.stdin.resume();
process.stdin.setEncoding('utf8');

fs.writeFile(file, '', () => {
  process.stdin.on('data', ( data ) => {
    fs.appendFile(file, data, (err) => {
      if (err !== null) {
        console.error(err);
      }
    });
  });
});

let tail = spawn("tail", ["-f", file]);
tail.stdout.setEncoding('utf8');
tail.stdout.on('data', (data) => {
  process.stdout.write(data);
});
