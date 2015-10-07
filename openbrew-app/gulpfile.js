var gulp = require('gulp');
var debug = require('gulp-debug');
var inject = require('gulp-inject');
var del = require('del');
 
gulp.task('default', function () {
    return gulp.src('foo.js')
        .pipe(debug({title: 'debug:'}))
        .pipe(gulp.dest('dist'));
});

gulp.task('clean', function(cb) {
    del(['dist/'], cb)
});

gulp.task('build', ['clean'], function () {

    // build from the MVC directories into dist.
    return gulp.src('src/www/index.html')
         .pipe(inject(gulp.src(['src/www/models/**/*.html']),{
            starttag: '<!-- inject:models:{{ext}} -->',
            transform: function (filePath, file) {
                return file.contents.toString('utf8')
            }
        }))
        .pipe(inject(gulp.src(['src/www/views/**/*.html']),{
            starttag: '<!-- inject:views:{{ext}} -->',
            transform: function (filePath, file) {
                return file.contents.toString('utf8')
            }
        }))
        .pipe(inject(gulp.src(['src/www/controllers/**/*.js']),{
            starttag: '<!-- inject:controllers:{{ext}} -->',
            transform: function (filePath, file) {
                return file.contents.toString('utf8')
            }
        }))
        .pipe(gulp.dest('dist/www'));

});
