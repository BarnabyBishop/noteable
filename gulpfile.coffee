gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
stylus = require 'gulp-stylus'
nodemon = require 'gulp-nodemon'

gulp.task 'lint', ->
    gulp.src ['models/*.coffee', 'views/*.coffee', 'public/**/*.coffee']
        .pipe coffeelint()
        .pipe coffeelint.reporter()

gulp.task 'coffee', ->
  gulp.src '/public/scripts/*.coffee'
    .pipe coffee({bare: true}) #.on('error', gutil.log)
    .pipe gulp.dest('/public/scripts/')

gulp.task 'stylus', ->
  gulp.src('/public/styles/*.styl')
    .pipe stylus()
    .pipe gulp.dest('/public/styles/build')

gulp.task 'start', ->
  nodemon({ script: 'app.coffee', ext: 'coffee styl', ignore: ['*.css, *.js'] })
    .on 'change', ['lint', 'coffee', 'stylus']
    .on 'restart', ->
      console.log('Restarted!')

gulp.task 'default', ['lint', 'coffee', 'stylus', 'start']