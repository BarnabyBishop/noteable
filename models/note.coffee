mongoose = require('mongoose')
Schema = mongoose.Schema

noteSchema = mongoose.Schema(
	_id:
		type: String  # will actually be a uuid
		required: true
	title: String
	text: String
)

module.exports = mongoose.model('Note', noteSchema)

###
	init = new Note(
		'title': 'init',
		'text': 'init text',
		'notid':  mongoose.Types.ObjectId('97c5f017c48947a59eb44f6cb68e18ac')) #'97c5f017c48947a59eb44f6cb68e18ac')
	init.save()
###