var gulp = require('gulp');
var debug = require('gulp-debug');
var inject = require('gulp-inject');
var del = require('del');
var cordovalib = require('cordova-lib');
var fs = require('fs');
var path = require('path');
var concat = require('gulp-concat');
var clean = require('gulp-clean');

var packages = require('./package.json');
var cordova = cordovalib.cordova.raw;
var builddir = path.join(__dirname, 'build');
 
gulp.task('default', function () {
    return gulp.src('foo.js')
        .pipe(debug({title: 'debug:'}))
        .pipe(gulp.dest('build'));
});

gulp.task('clean', function(cb) {
    return gulp.src(builddir)
        .pipe(clean());
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
        .pipe(inject(gulp.src(builddir + '/www/*.js'), {
            starttag: '<!-- inject:js -->'
        }))
        .pipe(gulp.dest('build/www'));

});

gulp.task('build-onsen-libs', function() {
    return gulp.src(['src/www/lib/**/*','src/www/res/**/*'], {base:"src/www"})
        .pipe(gulp.dest(builddir + '/www/'));
});

gulp.task('build-openbrew-css', function() {

});

gulp.task('build-openbrew-js', function() {
    return gulp.src(['src/www/controllers/**/*.js'])
    .pipe(concat('app.min.js'))
    .pipe(gulp.dest(builddir + '/www/'));

});


gulp.task('cordova', function(cb) {
    // add the target devices to the application in builddir
    return gulp.src(builddir)
    .pipe(cordova.build({
        "platforms": ["android","ios","browser"],
    }, cb));


});


gulp.task('build', ['clean', 'build-onsen-libs', 'build-openbrew-css', 'build-openbrew-js','buildindex', 'cordova'], function () {


});


