mongoose = require('mongoose')
Note = require('./note')
User = require('./user')

connStr = 'mongodb://localhost/noteable'

mongoose.connect(connStr,
				(err) ->
					if err
						throw err
				console.log('Successfully connected to MongoDB')
)

module.exports = { Note, User }

###
#Schema = mongoose.Schema
db.once('open', () ->
	noteSchema = mongoose.Schema(
		_id: String # will actually be a uuid
		title: String
		text: String
	)

	Note = mongoose.model('Note', noteSchema)

console.log('inserting user')
init = new User(
	'email': 'barneyb@gmail.com',
	'password': 'whocares')
init.save((err) ->
	if err
		console.log 'error: ' + err
	else
		consooe.log 'that worked i guess...'
)

###