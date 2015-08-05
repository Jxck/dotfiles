#!/usr/local/bin/node

var fs = require('fs');
var spawn = require('child_process').spawn;

var file = '/tmp/ws-broadcast.log';

process.stdin.resume();
process.stdin.setEncoding('utf8');

fs.writeFile(file, '', function() {
  process.stdin.on('data', function( data ) {
    fs.appendFile(file, data, function(err) {
      if (err !== null) {
        console.error(err);
      }
    });
  });
});

var tail = spawn("tail", ["-f", file]);
tail.stdout.setEncoding('utf8');
tail.stdout.on('data', function(data) {
  process.stdout.write(data);
});
