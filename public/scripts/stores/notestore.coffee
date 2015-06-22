$ = require 'jquery'
_ = require 'lodash'
Store = require './store.coffee'

class NoteStore extends Store
	notes: {}
	saveTimer: null
	constructor: ->
		super()

	loadNotes: (cb) ->
		$.ajax(url: '/getnotes')
			.then (data) =>
				# this data should be managed by the store...
				cb(data)
				for note in data
					@notes[note._id] = note

	getNotes: (cb) ->
		@loadNotes(cb)


	saveNote: (note) ->
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

	updateTextTitle: (noteId, position, title) ->
		textNode = @getTextNode(noteId, position)
		textNode.title = title
		@flagChange(noteId)

	updateText: (noteId, position, text) ->
		textNode = @getTextNode(noteId, position)
		textNode.text = text
		@flagChange(noteId)

	getTextNode: (noteId, position) ->
		note = @notes[noteId]
		return _.findWhere(note.texts, { 'position': position })

	flagChange: (noteId) ->
		if @saveTimer
			clearTimeout(@saveTimer)
		@saveTimer = setTimeout((=> @saveNote(@notes[noteId])), 500)

module.exports = NoteStore