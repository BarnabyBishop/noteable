mongoose = require('mongoose')
Schema = mongoose.Schema

noteSchema = mongoose.Schema(
	_id:
		type: String  # will actually be a uuid
		required: true
	title: String
	text: String
	path: String
	deleted:
		type: Boolean
		default: false
	list: [
		text: String
		checked: Boolean
	]
	lists: [
		title: String
		position: Number
		items: [
			text: String
			checked: Boolean
		]
	]
)

noteModel = mongoose.model('Note', noteSchema)

module.exports =
	get: (callback) ->
		noteModel.find({ 'deleted': false }, callback)

	save: (note, callback) ->
		_id = note._id

		# mongo gets cranky if you try and insert/update the _id
		# through the saved object
		delete note._id
		delete note.__v

		noteModel.findOneAndUpdate({ _id: _id }, note, { upsert:true }, callback)

	delete: (noteId, callback) ->
		noteModel.findOneAndUpdate({ _id: noteId }, { deleted: true }, callback)

