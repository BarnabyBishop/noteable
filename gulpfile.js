var gulp = require('gulp');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var stylus = require('gulp-stylus');
var nodemon = require('gulp-nodemon');
var browserify = require('browserify');  // Bundles JS.
var del = require('del');  // Deletes files.
var reactify = require('reactify');  // Transforms React JSX to JS.
var source = require('vinyl-source-stream');
var babelify = require('babelify');
var uglify = require('gulp-uglify');
var buffer = require('vinyl-buffer');

gulp.task('clean', function(done) {
  del(['build'], done);
});

gulp.task('copy-app', function() {
    gulp.src([
		'./models/**',
		'./routes/**',
		'./views/**',
		'./app.coffee'
    	], { "base" : "." })
    .pipe(gulp.dest('./build'));
});

gulp.task('stylus', function() {
  return gulp.src('public/styles/*.styl')
    .pipe(stylus())
    .pipe(gulp.dest('build'));
});

gulp.task('js', function() {
  browserify('./public/scripts/app.js')
    .transform(babelify)
    .bundle()
    .pipe(source('bundle.js'))
    // .pipe(buffer())
    // .pipe(uglify())
    .pipe(gulp.dest('build'));
});

gulp.task('watch', function() {
  gulp.watch('./public/styles/*.styl', ['css']);
  gulp.watch('./public/scripts/**/*', ['js']);
});


gulp.task('lint', function() {
  gulp.src(['models/*.coffee', 'views/*.coffee', 'public/**/*.coffee'])
      .pipe(coffeelint())
      .pipe(coffeelint.reporter());
});

gulp.task('start', function() {
	nodemon({
	    script: 'app.coffee',
	    ext: 'coffee styl js'
	  });
	//.on('change', ['lint', 'stylus', 'js'])
	//.on('restart', function() {
  //  	return console.log('Restarted!');
	//});
});

gulp.task('default', ['watch', 'lint', 'copy-app', 'stylus', 'js', 'start']);