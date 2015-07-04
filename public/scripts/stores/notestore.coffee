$ = require 'jquery'
_ = require 'lodash'
uuid = require 'uuid'
Store = require './Store.coffee'

notes = null

class NoteStore extends Store
	constructor: ->
		super()

	loadNotes: (cb) ->
		notes = {}
		$.ajax(url: '/getnotes')
			.then (data) =>
				for note in data
					notes[note._id] = note
				cb(notes)

	getNotes: (cb) ->
		if notes
			cb(notes)
		else
			@loadNotes(cb)

	getItems: (noteId) ->
		note = notes[noteId]
		items = []
		if note.texts?.length
			items = items.concat(note.texts)

		if note.lists?.length
			items = items.concat(note.lists)

		return items

	saveNote: (note) ->
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

	createNote: (path) ->
		id = uuid.v4()
		notes[id] =
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
		@notifyChange()
		@triggerSave(noteId)

	updateText: (noteId, position, text) ->
		textNode = @getTextNode(noteId, position)
		textNode.text = text
		@notifyChange()
		@triggerSave(noteId)

	getTextNode: (noteId, position) ->
		note = notes[noteId]
		return _.findWhere(note.texts, { 'position': position })

	addTextNode: (noteId) ->
		note = notes[noteId]
		note.texts.push({ position: note.texts.length })
		@notifyChange()

	addList: (noteId) ->
		note = notes[noteId]
		note.lists.push({ position: note.lists.length })
		@notifyChange()


	triggerSave: (noteId) ->
		_.debounce(@saveNote(notes[noteId]), 500)

module.exports = NoteStore