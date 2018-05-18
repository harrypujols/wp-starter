var gulp        = require('gulp'),
    sass        = require('gulp-sass'),
    webpack     = require('webpack-stream'),
    livereload  = require('gulp-livereload'),
    exec        = require('child_process').exec;

    gulp.task('webpack', ()=> {
      gulp.src('./src/static/js/index.js')
        .pipe(webpack( require('./webpack.config.js') ))
        .pipe(gulp.dest('./src'));
    })

    gulp.task('sass', ()=> {
      return gulp.src('./src/static/scss/*.scss')
            .pipe(sass({
              outputStyle : 'expanded'
            }).on('error', sass.logError))
            .pipe(gulp.dest('./src'))
            .pipe(livereload());
    })

    gulp.task('serve', function (cb) {
      exec('vagrant up', function (err, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);
        cb(err);
      });
    });
    
    gulp.task('default', function () {
      livereload.listen();
      gulp.watch('./src/static/scss/**/*.scss', ['sass']);
      gulp.watch('./src/static/js/**/*.js', ['webpack']);
    });
    


