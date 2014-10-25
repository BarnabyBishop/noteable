mongoose = require('mongoose')
Folder = require('./folder')
Note = require('./note')
User = require('./user')

connStr = 'mongodb://localhost/noteable'

mongoose.connect(connStr,
				(err) ->
					if err
						throw err
				console.log('Successfully connected to MongoDB')
)

module.exports = { Folder, Note, User }