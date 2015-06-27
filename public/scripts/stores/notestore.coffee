$ = require 'jquery'
_ = require 'lodash'
uuid = require 'uuid'
Store = require './store.coffee'

class NoteStore extends Store
	notes: null
	constructor: ->
		super()

	loadNotes: (cb) ->
		@notes = {}
		$.ajax(url: '/getnotes')
			.then (data) =>
				for note in data
					@notes[note._id] = note
				cb(@notes)

	getNotes: (cb) ->
		if @notes
			cb(@notes)
		else
			@loadNotes(cb)

	saveNote: (note) ->
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

	createNote: (path) ->
		id = uuid.v4()
		@notes[id] =
			_id: id
			title: ''
			path: path
			deleted: false
			texts: []
			lists: []
		
		return id

	updateTextTitle: (noteId, position, title) ->
		textNode = @getTextNode(noteId, position)
		textNode.title = title
		@triggerSave(noteId)

	updateText: (noteId, position, text) ->
		textNode = @getTextNode(noteId, position)
		textNode.text = text
		@triggerSave(noteId)

	getTextNode: (noteId, position) ->
		note = @notes[noteId]
		return _.findWhere(note.texts, { 'position': position })

	addTextNode: (nodeId) ->
		note = @notes[noteId]

	triggerSave: (noteId) ->
		_.debounce(@saveNote(@notes[noteId]), 500)

module.exports = NoteStore