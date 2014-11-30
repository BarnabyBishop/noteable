config = port: 3000

module.exports = (grunt) ->

	# Load grunt tasks automatically
	require('load-grunt-tasks')(grunt)

	# Time how long tasks take. Can help when optimizing build times
	require('time-grunt')(grunt)


	# Project configuration.
	grunt.initConfig(
		pkg: grunt.file.readJSON('package.json')
		express:
			options:
				port: config.port
			dev:
				options:
					script: 'app.coffee'
					debug: true
		coffeelint:
			app: ['*.coffee', '/public/scripts/*.coffee'],
			options:
				configFile: 'coffeelint.json'

		coffee:
			compile:
				files:
					'public/scripts/index.js': 'public/scripts/index.coffee'
		stylus:
			compile:
				files: 'public/styles/style.css': 'public/styles/style.styl'

		nunjucks:
			precompile:
				baseDir: 'views/',
				src: 'views/*',
				dest: 'public/scripts/templates.js'

		shell:
			mongodb:
				command: 'C:\\Users\\B\\Projects\\mongodb\\bin\\mongod.exe',
				options:
					async: true,
					stdout: false,
					stderr: true,
					failOnError: true,
					execOptions:
						cwd: '.'

		concurrent:
			dev:
				tasks: ['nodemon', 'node-inspector', 'watch'],
				options:
					logConcurrentOutput: true

		'node-inspector':
			custom:
				options:
					'web-host': 'localhost'

		nodemon:
			debug:
				script: 'app.coffee',
				options:
					#nodeArgs: ['--debug'],
					env:
						port: config.port

		watch:
			coffee:
				files: [
					'model/**/*.coffee',
					'routes/**/*.coffee',
					'*.coffee',
					'public/scripts/*.coffee'
				],
				tasks: ['coffeelint', 'coffee']

			stylus:
				files: [
					'public/styles/*.styl'
				],
				tasks: ['stylus']

			nunjucks:
				files: 'views/*',
				tasks: ['nunjucks']

			express:
				files: [
					'app.coffee',
					'public/js/lib/**/*.{js,json}'
				],
				tasks: ['coffeelint', 'coffee', 'stylus', 'concurrent:dev']
		)

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-stylus')
	grunt.loadNpmTasks('grunt-nunjucks')

	# default option to connect server
	grunt.registerTask('default', (target) ->
		grunt.task.run([
			'coffeelint',
			'coffee',
			'nunjucks',
			'shell:mongodb',
			'concurrent:dev'
		])
	)
