console.log 'added discrimato'
util = require('util')
mongoose = require('mongoose')
Schema = mongoose.Schema

NoteItemSchema = ->
	Schema.apply(this, arguments)

util.inherits(NoteItemSchema, Schema)

noteItemSchema = new NoteItemSchema()

noteTextSchema = new NoteItemSchema
	title: String
	text: String

noteListSchema = new NoteItemSchema
	title: String
	items: [
		text: String
		checked: Boolean
	]

NoteItem = mongoose.model('NoteItem', noteItemSchema)
NoteText = NoteItem.discriminator('NoteText', noteTextSchema)
NoteList = NoteItem.discriminator('NoteList', noteListSchema)

# http://www.laplacesdemon.com/2014/02/19/model-inheritance-node-js-mongoose/


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
	items: [NoteItemSchema]
)

console.log 'yay'

noteModel = mongoose.model('Note', noteSchema)

module.exports =
	get: (callback) ->
		console.log 'gettin'
		noteModel.find({ 'deleted': false }, callback)

	save: (note, callback) ->
		console.log 'settin', note
		_id = note._id

		# mongo gets cranky if you try and insert/update the _id
		# through the saved object
		delete note._id
		delete note.__v

		noteModel.findOneAndUpdate({ _id: _id }, note, { upsert:true }, callback)

	delete: (noteId, callback) ->
		noteModel.findOneAndUpdate({ _id: noteId }, { deleted: true }, callback)

