/*eslint global-strict:0, func-names:0*/
'use strict';
var gulp = require('gulp')
  , connect = require('gulp-connect')
  , eslint = require('gulp-eslint')
  , mocha = require('gulp-mocha')
  , espower = require('gulp-espower')
  , rimraf = require('gulp-rimraf')
  , bower = require('main-bower-files')
  ;

/**
 * .
 * index.html
 *    /build - compiled
 *    /lib   - bower components
 *    /src   - javascripts
 *    /test  - tests
 *
 *  "devDependencies": {
 *    "gulp": "*",
 *    "gulp-connect": "*",
 *    "gulp-jshint": "*",
 *    "gulp-mocha": "*",
 *    "gulp-rimraf": "*",
 *    "gulp-tsc": "*",
 *    "jshint-stylish": "*",
 *    "main-bower-files": "*"
 *  },
 *
 */

// server starts at root with port 3000
gulp.task('server', function() {
  return connect.server({
    port: 3000,
    livereload: true
  });
});

//TODO: use "npm run lint" until gulp-eslint upgraded to eslint@0.10'
// all javascript sources are in /src
gulp.task('lint', function() {
  return gulp.src([ 'src/**/*.js', 'test/*.js' ])
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failOnError());
});

// all bower componets are copy in /lib
gulp.task('bower', function() {
  return gulp.src(bower())
    .pipe(gulp.dest('lib'));
});

// all test are in /test, convert to power-assert in /tmp
gulp.task('power-assert', function () {
  return gulp.src('./test/*.js')
    .pipe(espower())
    .pipe(gulp.dest('./tmp/'));
});

// run all power-asserted test in /tmp
gulp.task('test', ['power-assert'], function () {
  return gulp.src('./tmp/*.js')
    .pipe(mocha({ reporter: 'spec' }));
});

// clean under build/*
gulp.task('clean', function () {
  return gulp.src([ 'build/*.js', 'tmp/*' ], { read: false })
    .pipe(rimraf({ force: true }));
});

// for typescript
gulp.task('compile', function () {
  return gulp.src(['src/*.ts'])
    .pipe(typescript())
    .pipe(gulp.dest('dest/'));
});
