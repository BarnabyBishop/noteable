mongoose = require('mongoose')
Schema = mongoose.Schema

folderSchema = mongoose.Schema(
	_id:
		type: String  # will actually be a uuid
		required: true
	name: String
	parent: String
	deleted: Boolean
)

module.exports = mongoose.model('Folder', folderSchema)
