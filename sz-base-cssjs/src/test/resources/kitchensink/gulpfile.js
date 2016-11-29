// Resources in Test


var BASEDIR = '../../../..';

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

var ASSETSDIR = path.join(BASEDIR, 'target/assets');
var CSSASSETSDIR = path.join(ASSETSDIR, 'css');
var JSASSETSDIR = path.join(ASSETSDIR, 'js');

var sassPaths = [
	path.join(BASEDIR, 'target/classes/foundation-sites/scss'),
	path.join(BASEDIR, 'target/classes/motion-ui/src'),
	path.join(BASEDIR, 'target/classes/asciidoctor/scss'),
	path.join(BASEDIR, 'target/classes/normalize')
];


var es = require('event-stream');
var logFile = function (comment, es) {
	return es.map(function (file, cb) {
		gutil.log(comment + ':' + file.path);
		return cb();
	});
};

gulp.task('default', ['sass']);


gulp.task('sass', function () {
	gulp.src('*.scss')
			.pipe(logFile('I', es));
	return gulp.src('*.scss')
			.pipe(sass({
				includePaths: sassPaths
			})
					.on('error', sass.logError))
			//      .pipe($.autoprefixer({
			//             browsers: ['last 2 versions', 'ie >= 9']
			//    }))
			.pipe(gulp.dest('.'))
			.pipe(logFile('O', es))
			;
});
