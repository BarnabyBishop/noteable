mongoose = require('mongoose')
connStr = 'mongodb://localhost/noteable'

mongoose.connect(connStr,
				(err) ->
					if err
						throw err
				console.log('Successfully connected to MongoDB')
)

module.exports =
	folder: require('./folder')
	note: require('./note')
	user: require('./user')