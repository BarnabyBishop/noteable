mongoose = require('mongoose')
Schema = mongoose.Schema

folderSchema = mongoose.Schema(
	_id:
		type: String  # will actually be a uuid
		required: true
	name: String
	path: String
	mode: String
	deleted: Boolean
)

folderModel = mongoose.model('Folder', folderSchema)

module.exports =
	get: (callback) ->
		folderModel.find({ 'deleted': false }, callback)

	save: (folder, callback) ->
		_id = folder._id

		# mongo gets cranky if you try and insert/update the _id
		# and version (__v) through the saved object
		delete folder._id
		delete folder.__v

		folderModel.findOneAndUpdate({ _id: _id }, folder, { upsert:true }, callback)

	delete: (folderId, callback) ->
		folderModel.findOneAndUpdate({ _id: folderId }, { deleted: true }, callback)


