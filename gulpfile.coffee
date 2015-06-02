gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
stylus = require 'gulp-stylus'
nodemon = require 'gulp-nodemon'
webpack = require 'gulp-webpack'
#watch = require 'gulp-watch'

gulp.task 'lint', ->
	gulp.src ['models/*.coffee', 'views/*.coffee', 'public/**/*.coffee']
		.pipe coffeelint()
		.pipe coffeelint.reporter()


gulp.task 'webpack', (callback) ->
	# run webpack
	gulp.src('public/scripts/start.js')
		#.pipe(watch('public/scripts/**/*.(coffee|cjsx)'))
		.pipe(webpack(
			{
				output: {
		        	filename: 'bundle.js',
		      	},
				module: {
					loaders: [
						{ test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx-loader']},
						{ test: /\.coffee$/, loader: 'coffee-loader' },
						{ test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" }
					]
				}
			}))
		.pipe(gulp.dest('build/public/scripts'))

gulp.task 'stylus', ->
	gulp.src('public/styles/*.styl')
		.pipe stylus()
		.pipe gulp.dest('build/public/styles')

gulp.task 'start', ->
	nodemon({ script: 'app.coffee', ext: 'coffee styl', ignore: ['*.css, *.js'] })
		.on 'change', ['lint', 'webpack', 'stylus']
		.on 'restart', ->
			console.log('Restarted!')

gulp.task 'watch', ->
	gulp.watch('public/scripts/**/*', ['webpack'])
	gulp.watch('public/styles/**/*', ['stylus'])

gulp.task 'default', ['watch', 'lint', 'webpack', 'stylus', 'start']