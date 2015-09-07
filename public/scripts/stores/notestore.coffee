$ = require 'jquery'
_ = require 'lodash'
uuid = require 'uuid'
Store = require './Store.coffee'

notes = null
selectedNoteId = null

class NoteStore extends Store
	constructor: ->
		super()
		@triggerSave = _.debounce(@saveNote, 500)

	loadNotes: (cb) ->
		notes = {}
		$.ajax(url: '/getnotes')
			.then (data) ->
				for note in data
					notes[note._id] = note

				cb()

	buildNoteList: (path) ->
		noteList = []
		for note of notes
			console.log 'if not ', path, ' or ', path, ' is ', note.path
			if not path or path is notes[note].path
				noteList.push(notes[note])

		return noteList

	getNotes: (path, cb) ->
		if notes
			cb(@buildNoteList(path))
		else
			@loadNotes =>
				cb(@buildNoteList(path))

	getItems: (noteId) ->
		note = notes[noteId]
		items = []
		if note.texts?.length
			items = items.concat(note.texts)

		if note.lists?.length
			items = items.concat(note.lists)

		return items

	saveNote: (noteId) ->
		note = notes[noteId]
		$.ajax
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(note)

	deleteNote: (noteId) ->
		$.ajax
			type: 'POST',
			url: '/deletenote',
			data:
				_id: id

	addNote: (path) ->
		id = uuid.v4()
		notes[id] =
			_id: id
			path: path
			deleted: false
			texts: [
				position: 0
			]
			lists: []

		selectedNoteId = id

		@notifyChange()

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

	getSelectedNote: ->
		return notes[selectedNoteId] or null

	updateSelectedNoteId: (noteId) ->
		selectedNoteId = noteId
		@notifyChange()


noteStore = new NoteStore()
module.exports = noteStore