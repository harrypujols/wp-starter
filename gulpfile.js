'use strict';

var gulp = require('gulp'),
    sass = require('gulp-sass'),
    livereload = require('gulp-livereload'),
    browserify = require('browserify'),
    babelify = require('babelify'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer');

gulp.task('sass', function () {
  return gulp.src('./src/static/scss/style.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./'))
    .pipe(livereload());
});

gulp.task('babel', function () {
  var b = browserify({
  entries: './src/static/js/index.js',
  debug: true,
	transform: [babelify.configure({
		  presets: ['es2015']
    })]
  });

  return b.bundle()
    .pipe(source('scripts.js'))
    .pipe(buffer())
    .pipe(gulp.dest('./'));
});

gulp.task('default', function () {
  livereload.listen();
  gulp.watch('./src/static/scss/**/*.scss', ['sass']);
  gulp.watch('./src/static/js/**/*.js', ['babel']);
});
