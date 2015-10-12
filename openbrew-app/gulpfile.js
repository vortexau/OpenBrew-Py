var gulp = require('gulp');
var debug = require('gulp-debug');
var inject = require('gulp-inject');
var del = require('del');
var cordovalib = require('cordova-lib');



var packages = require('./package.json');
var cordova = cordovalib.cordova.raw;
var builddir = path.join(__dirname, 'build');






 
gulp.task('default', function () {
    return gulp.src('foo.js')
        .pipe(debug({title: 'debug:'}))
        .pipe(gulp.dest('build'));
});

gulp.task('clean', function(cb) {
    del(['build'], cb)
});




gulp.task('buildindex', function () {

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
        .pipe(gulp.dest('build/www'));

});

gulp.task('buildcss', function() {

});


gulp.task('cordova', function() {
    // add the target devices to the application in builddir


});


gulp.task('build', ['clean', 'buildindex', 'buildcss', 'cordova'], function () {


});


