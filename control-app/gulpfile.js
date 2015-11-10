var gulp = require('gulp');
var debug = require('gulp-debug');
var inject = require('gulp-inject');
var del = require('del');
var fs = require('fs');
var path = require('path');
var concat = require('gulp-concat');
var runSequence = require('run-sequence');
var create = require('gulp-cordova-create');
var plugin = require('gulp-cordova-plugin');
var pref = require('gulp-cordova-preference');
var android = require('gulp-cordova-build-android');
var ios = require('gulp-cordova-build-ios');
var description = require('gulp-cordova-description');
var icon = require('gulp-cordova-icon');

var packages = require('./package.json');
var builddir = path.join(__dirname, 'build');
//var releasedir = path.join(__dirname, 'release');
var releasedir = 'release';

var platforms = ['android'];  // List like ['cordova-ios', 'cordova-android']
var platform_dirs = ['cordova-ios','cordova-android'];  // List of subdirs with platform files under node_moduels
 
gulp.task('default', function () {
    return gulp.src('foo.js')
        .pipe(debug({title: 'debug:'}))
        .pipe(gulp.dest('build'));
});

gulp.task('clean', function(cb) {
    return del([builddir, releasedir]);
    err(cb);
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
    return gulp.src(['src/hooks/**/*','src/www/icon.png', 'src/www/lib/**/*','src/res/**/*'], {base:"src/www"})
        .pipe(gulp.dest(builddir + '/www/'));
});

gulp.task('build-openbrew-css', function() {

});

gulp.task('build-openbrew-js', function() {
    return gulp.src(['src/www/controllers/**/*.js'])
    .pipe(concat('app.min.js'))
    .pipe(gulp.dest(builddir + '/www/'));

});

gulp.task('junk', function() {
    return gulp.src(builddir + '/icon.png')
    .pipe(gulp.dest(releasedir))
    .pipe(debug());
});

gulp.task('cordova', function() {

    var options = {
        dir: releasedir,
        id: packages.appid,
        name: packages.name
    };

    return gulp.src(builddir)
        .pipe(debug())
        .pipe(create(options))
        .pipe(description(packages.description))
        .pipe(icon(releasedir + '/www/icon.png'))
        .pipe(android());

});

gulp.task('build', function (callback) {
    runSequence('clean', 
        ['build-onsen-libs', 'build-openbrew-css', 'build-openbrew-js','buildindex'],
        'cordova',
        callback);

});


