var gulp = require('gulp');
//var browserSync = require('browser-sync').create();

var $ = require('gulp-load-plugins')();

var sassPaths = [
	'bower_components/foundation-sites/scss',
	'bower_components/motion-ui/src',
	'asciidoctor/scss'
];

gulp.task('sass', function () {
	return gulp.src('${gulp.src}')
			.pipe($.sass({
				includePaths: sassPaths
			})
					.on('error', $.sass.logError))
			.pipe($.autoprefixer({
				browsers: ['last 2 versions', 'ie >= 9']
			}))
			.pipe(gulp.dest('${gulp.dest}'));
});