$ = require '../libs/jquery'
Store = require './store.coffee'

class NoteStore extends Store
	constructor: -> super()

	getNotes: (cb) ->
		$.ajax(url: '/getnotes')
			.then (data) ->
				cb(data)

	saveNote: (note) ->
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

module.exports = NoteStore