// streichelzoo specific rules for building foundation sites

// this file will be copied into target/classes

// resulting css and js must be placed into assets dir META-INF/resources/streichelzoo
// where "streichelzoo" is the resource library


var BASEDIR = '../..';  // as seen from target/classes

// for logging the current file in pipe(logFile(es))
var es = require('event-stream');
var logFile = function (comment, es) {
	return es.map(function (file, cb) {
		gutil.log(comment + ':' + file.path);
		return cb();
	});
};

var gulp = require('gulp');
var cssnano = require('gulp-cssnano');
var rename = require('gulp-rename');
var path = require('path');
var gutil = require('gulp-util');
var babel = require('gulp-babel');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var addSrc = require('gulp-add-src');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');

var SCSSFILES = path.join(BASEDIR, 'src/main/resources/scss/**/*.scss');
var JSFILES = ['foundation-sites/js/**/*.js',
	'jquery/dist/jquery.js',
	'what-input/dist/what-input.js',
	path.join(BASEDIR, 'src/main/resources/js/app.js')
];
var CSSASSETSDIR = 'META-INF/resources/streichelzoo/css';
var JSASSETSDIR = 'META-INF/resources/streichelzoo/js';

// root dir will be target/classes and there maven remote resources are available
var sassPaths = [
	'normalize',
	'foundation-sites/scss',
	'motion-ui/src'
];

gulp.task('default', ['sass', 'sassmin', 'sassminvanilla', 'js:foundation', 'js:deps']);

gulp.task('sass', function () {
	gulp.src(SCSSFILES).pipe(logFile('I', es));
	return gulp.src(SCSSFILES)
			.pipe(sass({
				includePaths: sassPaths
			}).on('error', sass.logError))
			.pipe(autoprefixer({
				browsers: ['last 2 versions', 'ie >= 9', 'Android >= 2.3']
			}))
			.pipe(gulp.dest(CSSASSETSDIR))
			.pipe(logFile('O', es));
});

// Creates a Sass file from the module/variable list and creates foundation.css and foundation.min.css
gulp.task('sassmin', function () {
	return gulp.src(SCSSFILES)
			.pipe(sass({
				includePaths: sassPaths
			}).on('error', sass.logError))
			.pipe(autoprefixer({
				browsers: ['last 2 versions', 'ie >= 9']
			}))
			.pipe(cssnano())
			.pipe(rename(function (path) {
				path.extname = ".min.css";
			}))
			.pipe(gulp.dest(CSSASSETSDIR))
			.pipe(logFile('O', es));
});

// no autoprefixer
gulp.task('sassminvanilla', function () {
	return gulp.src(SCSSFILES)
			.pipe(sass({
				includePaths: sassPaths
			}).on('error', sass.logError))
			.pipe(cssnano())
			.pipe(rename(function (path) {
				path.extname = ".vmin.css";
			}))
			.pipe(gulp.dest(CSSASSETSDIR))
			.pipe(logFile('O', es));
});


var onBabelError = require('./babel-error.js');

var FOUNDATION = [
  'foundation-sites/js/foundation.core.js',
  'foundation-sites/js/foundation.util.*.js',
  'foundation-sites/js/*.js'
];

var DEPS = [
  //'node_modules/jquery/dist/jquery.js', 
  'jquery/dist/jquery.js',  // local alternative
  'node_modules/motion-ui/dist/motion-ui.js',
  'node_modules/what-input/what-input.js'
];

var DOCS = [
  'node_modules/clipboard/dist/clipboard.js',
  'node_modules/corejs-typeahead/dist/typeahead.bundle.js',
  'node_modules/foundation-docs/js/**/*.js',
  'docs/assets/js/docs.*.js',
  'docs/assets/js/docs.js'
];

// Compiles JavaScript into a single file
gulp.task('js', ['js:foundation', 'js:deps', 'js:docs']);

gulp.task('js:foundation', function() {
  return gulp.src(FOUNDATION)
    .pipe(babel()
      .on('error', onBabelError))
    .pipe(gulp.dest(path.join(JSASSETSDIR, 'plugins')))
    .pipe(concat('foundation.js'))
    .pipe(gulp.dest(JSASSETSDIR))
	.pipe(uglify())
    .pipe(rename({ suffix: '.min' }))
    .pipe(gulp.dest(JSASSETSDIR))
	;
});

gulp.task('js:deps', function() {
  return gulp.src(DEPS)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(JSASSETSDIR));
});

gulp.task('js:docs', function() {
  return gulp.src(DOCS)
    .pipe(concat('docs.js'))
    .pipe(gulp.dest(JSASSETSDIR));
});
