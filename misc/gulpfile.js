/*eslint global-strict:0*/
'use strict';
var gulp = require('gulp')
  , del = require('del')
  , connect = require('gulp-connect')
  , mocha = require('gulp-mocha')
  , espower = require('gulp-espower')
  , bower = require('main-bower-files')
  , eslint = require('gulp-eslint')
  ;

/**
 * .
 * /build - compiled
 * /lib   - bower components
 * /src   - javascripts
 * /test  - tests
 * /tmp   - temporally files
 */

// server starts at root with port 3000
gulp.task('server', function() {
  return connect.server({
    port: 3000,
    livereload: true
  });
});

// eslint all javascripts
gulp.task('lint', function() {
  return gulp.src([ 'src/**/*.js', 'test/**/*.js', 'index.js', 'gulpfile.js' ])
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failOnError());
});

// all bower componets are copy in /lib
gulp.task('bower', function() {
  return gulp.src(bower({ includeDev: 'inclusive' }))
    .pipe(gulp.dest('lib'));
});

// all test are in /test, convert to power-assert in /tmp
gulp.task('power-assert', function() {
  return gulp.src('test/*.js')
    .pipe(espower())
    .pipe(gulp.dest('tmp'));
});

// run all power-asserted test in /tmp
gulp.task('test', ['power-assert'], function() {
  return gulp.src('tmp/*.js')
    .pipe(mocha({ reporter: 'spec' }));
});

// clean temporally files
gulp.task('clean', function(cb) {
  return del([ 'build/*.js', 'lib/*', 'tmp/*', 'npm-debug.log', '!*/.gitkeep' ], cb);
});

// clean all dependencies and temporally files
gulp.task('clean-all', ['clean'], function(cb) {
  return del([ 'node_modules', 'bower_components' ], cb);
});
