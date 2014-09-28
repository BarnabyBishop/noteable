'use strict()';

var config= {
	port: 3000
};

module.exports = function(grunt) {

	// Load grunt tasks automatically
	require('load-grunt-tasks')(grunt);

	// Time how long tasks take. Can help when optimizing build times
	require('time-grunt')(grunt);

	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		express: {
			options: {
				port: config.port
			},
			dev: {
				options: {
					script: 'app.js',
					debug: true
				}
			}
		},

		coffee: {
		  compile: {
		    files: {
		      'app.js': 'app.coffee',
		    }
	  	},
		},

		coffeelint: {
      app: ['*.coffee', '/public/scripts/*.coffee'],
     	options: {
        'no_tabs': {
          'level': 'ignore'
        }
      }    
    },

    shell: {
    	mongodb: {
        command: 'C:\\Users\\B\\Projects\\mongodb\\bin\\mongod.exe',
        options: {
            async: true,
            stdout: false,
            stderr: true,
            failOnError: true,
            execOptions: {
                cwd: '.'
            }
        }
    	}
		},

		concurrent: {
			dev: {
				tasks: ['nodemon', 'node-inspector', 'watch'],
				options: {
					logConcurrentOutput: true
				}
			}
		},

		'node-inspector': {
			custom: {
				options: {
					'web-host': 'localhost'
				}
			}
		},

		nodemon: {
			debug: {
				script: 'app.js',
				options: {
					nodeArgs: ['--debug'],
					env: {
						port: config.port
					}
				}
			}
		},

		
		watch: {
			coffee: {
				files: [
					'model/**/*.coffee',
					'routes/**/*.coffee',
					'*.coffee'
				],
				tasks: ['coffeelint']
			},
			express: {
				files: [
					'app.js',
					'public/js/lib/**/*.{js,json}'
				],
				tasks: ['coffee', 'coffeelint', 'concurrent:dev']
			},
			livereload: {
				files: [
					'public/styles/**/*.css',
					'public/styles/**/*.less',
					'templates/**/*.jade',
					'node_modules/keystone/templates/**/*.jade'
				],
				options: {
					livereload: true
				}
			}
		}});

	grunt.loadNpmTasks('grunt-contrib-coffee');

	// default option to connect server
	grunt.registerTask('serve', function(target) {
		grunt.task.run([
			'coffee',
			'coffeelint',
			'shell:mongodb',
			'concurrent:dev'
		]);
	});

	grunt.registerTask('server', function () {
		grunt.log.warn('The `server` task has been deprecated. Use `grunt serve` to start a server.');
		grunt.task.run(['serve:' + target]);
	});

};
