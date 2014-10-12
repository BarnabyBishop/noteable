mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/noteable')

db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))
db.once('open', () ->
	noteSchema = mongoose.Schema(
		title: String
		text: String
	)

	Note = mongoose.model('Note', noteSchema)
)