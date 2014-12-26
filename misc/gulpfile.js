var gulp = require('gulp')
  , jshint = require('gulp-jshint')
  , stylish = require('jshint-stylish')
  , bower = require('main-bower-files')
  , mocha = require('gulp-mocha')
  , connect = require('gulp-connect')
  , typescript = require('gulp-tsc')
  , rimraf = require('gulp-rimraf')
  ;

/**
 * .
 * index.html
 *    /dest - compiled
 *    /lib  - bower components
 *    /src  - javascripts
 *    /test - tests
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

// all javascript sources are in /src
gulp.task('lint', function() {
  return gulp.src(['./src/*.js'])
    .pipe(jshint())
    .pipe(jshint.reporter(stylish));
});

// all bower componets are copy in /lib
gulp.task('bower', function() {
  return gulp.src(bower())
    .pipe(gulp.dest('lib'));
});

// all test are in /test
gulp.task('test', function() {
  return gulp.src('./test/*.js')
    .pipe(mocha({ reporter: 'spec' }));
});

// clean under dest/*
gulp.task('clean', function () {
  return gulp.src('dest/*.js', { read: false })
    .pipe(rimraf({ force: true }));
});

// for typescript
gulp.task('compile', function () {
  return gulp.src(['src/*.ts'])
    .pipe(typescript())
    .pipe(gulp.dest('dest/'));
});
