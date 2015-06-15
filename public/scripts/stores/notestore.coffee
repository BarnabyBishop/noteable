$ = require '../libs/jquery'
Store = require './store.coffee'

class NoteStore extends Store
	@notes = []
	constructor: ->
		super()

	loadNotes: ->
		$.ajax(url: '/getnotes')
			.then (data) ->
				# this data should be managed by the store...
				cb(data)


	getNotes: (cb) ->

	saveNote: (note) ->
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

	updateListItem: (item, noteId) ->


module.exports = NoteStore