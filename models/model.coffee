mongoose = require('mongoose')
connStr = 'mongodb://localhost/noteable'

mongoose.connect(connStr, (err) -> throw err if err)

module.exports =
	folder: require('./folder')
	note: require('./note')
	user: require('./user')
