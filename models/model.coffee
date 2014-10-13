mongoose = require('mongoose')
Schema = mongoose.Schema
mongoose.connect('mongodb://localhost/noteable')

db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))
db.once('open', () ->
	noteSchema = mongoose.Schema(
		_id: String # will actually be a uuid
		title: String
		text: String
	)

	Note = mongoose.model('Note', noteSchema)
)
###
	init = new Note(
		'title': 'init',
		'text': 'init text',
		'notid':  mongoose.Types.ObjectId('97c5f017c48947a59eb44f6cb68e18ac')) #'97c5f017c48947a59eb44f6cb68e18ac')
	init.save()
###