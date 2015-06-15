$ = require './libs/jquery'
uuid = require './libs/uuid'
List = require './components/list.cjsx'
React = require './libs/react'
NoteStore = require './stores/notestore.coffee'

noteStore = new NoteStore()

notes = {}
folders = {}
editAmount = 0
editTimer = false
currentPath = ''

Items = React.createClass
	render: ->
		createItem = (item) ->
			<List title={item.title} position={item.position} items={item.items} />

		<div>{@props.items.map(createItem)}</div>

selectNote = (element) ->
	$('.notelist .selected').removeClass('selected')
	element.addClass('selected')

	note = notes[element.attr('data-id')]
	$('.note .title').val(note.title).attr('data-id', note._id)
	$('.note .text').val(note.text).attr('data-id', note._id)

	if note.lists?.length
		console.log('rendering...', note.lists)
		React.render <Items lists={note.lists} texts={note.textitems} />,
			document.getElementById('items')
	# $('.list').empty()
	# if note.list?.length
	# 	renderList($('.list'), note.list)

setValue = (elements, value) ->
	elements.each(
		->
			element = $(this)
			if (element.is("input") or element.is("textarea"))
				element.value(value)
			else
				element.text(value)
		)

editNoteField = (control, value) ->
	id = control.attr('data-id')
	if not id
		id = createNote()

	field = control.attr('data-field')
	notes[id][field] = value

	setValue($("[data-field=#{field}][data-id=#{id}]").not(control), value)

	setSaveTimer(id)

saveNote = (id) ->
	noteStore.saveNote(notes[id])

addNoteToList = (note) ->
	element = $("<div data-id='#{note._id}' data-field='title'>#{note.title}</div>")
	$('.notelist').append(element)
	element.click( ->
		selectNote($(this))
	)
	return element

removeNoteFromList = (noteId) ->
	$(".notelist [data-id='#{noteId}'").remove()
	$('.note .title').val('').attr('data-id', '')
	$('.note .text').val('').attr('data-id', '')

	# $('.note .list').empty()

createNote = ->
	# $('.list').empty()
	clearInputs()
	id = uuid.v4()
	notes[id] =
		_id: id
		title: ''
		path: $('.currentfolder').attr('data-current-path')
		deleted: false
	$('.note .title').attr('data-id', id)
	$('.note .text').attr('data-id', id)
	noteListElement = addNoteToList(notes[id])
	$('.notelist .selected').removeClass('selected')
	noteListElement.addClass('selected')
	$('.note .title').focus()
	return id

deleteNote = ->
	id = $('.note .title').attr('data-id')
	if id
		$.ajax(
			type: 'POST',
			url: '/deletenote',
			data:
				_id: id
		)
	removeNoteFromList(id)

bindFolderList = ->
	$('.folderlist .panel .folder').remove()
	for id, folder of folders
		if folder.path.substring(0, folder.path.lastIndexOf(",#{folder.name},")) is currentPath or id is ''
			addFolderToList(folder)

addFolderToList = (folder) ->
	node = $("<div data-id='#{folder._id}' data-path='#{folder.path}' class='folder' data-type='folder' data-field='name'><i class='icon ion-ios7-bookmarks-outline'></i><div data-id='#{folder._id}'>#{folder.name if folder.name?}</div></div>")
	$('.folderlist .panel .newfolder').before(node)
	node.click( ->
		selectFolder($(this))
	)

selectFolder = (folderElement)->
	currentPath = folderElement.attr('data-path')
	folderId = folderElement.attr('data-id')
	$('.currentfolder')
		.attr('data-current-path', currentPath)
		.text(folders[folderId].name)
	$('.notelist').empty()
	# $('.list').empty()
	for note of notes
		if notes[note].path is currentPath
			addNoteToList(notes[note])
	toggleFolderList()
	clearInputs()
	bindFolderList()

editFolder = (control, value) ->
	id = control.attr('data-id')

	folders[id].name = value
	# If the user has stopped typing for 1 second Or made over 50 changes save
	if editFolderTimer
		clearTimeout(editFolderTimer)
	editFolderTimer = setTimeout((-> saveFolder(id)), 500)

createFolder = ->
	folderName = $('.foldername').val()
	currentFolder = $('.currentfolder').attr('data-current-path')
	if folderName
		id = uuid.v4()
		folders[id] =
			_id: id
			name: folderName
			path: "#{if currentFolder then currentFolder else ''},#{folderName},"
			deleted: false

		saveFolder(id)
		addFolderToList(folders[id])


	$('.foldername').text('').hide()
	$('.confirmfolder').hide()

saveFolder = (id) ->
	$.ajax(
		type: 'POST',
		url: '/savefolder',
		data: folders[id]
	)

toggleFolderList = ->
	$('.folderlist').find('.panel').toggle()

clearInputs = ->
	$('.note .title').val('')
	$('.note .text').val('')
	$('.note .title').attr('data-id', '')
	$('.note .text').attr('data-id', '')

setSaveTimer  = (id) ->
	# If the user has stopped typing for 1 second Or made over 50 changes save
	if editTimer
		clearTimeout(editTimer)
	if ++editAmount == 50
		editAmount = 0
		saveNote(id)
	else
		editTimer = setTimeout((-> saveNote(id)), 500)

module.exports = ->
	if window.location.pathname and window.location.pathname isnt '/'
		currentPath = decodeURI(window.location.pathname).replace(/\//g, ',,')
		currentPath = currentPath.substring(1) + ','
		console.log currentPath

	# Load notes from server
	$.ajax(url: "/getfolders")
	.then(
		(data) ->
			folders[''] =
				_id: ''
				name: '/'
				path: ''
			for folder in data
				folders[folder._id] = folder

			bindFolderList()
	)


	noteStore.getNotes (notes) ->
		notes.forEach (note) ->
			notes[note._id] = note
			if note.path is currentPath
				addNoteToList(note)

	# prepare inputs for editing
	$('.note .title').on('input', -> editNoteField($(this), this.value))
	$('.note .text') .on('input', -> editNoteField($(this), this.value))
	$('.newnote').on('click', createNote)
	$('.deletenote').on('click', deleteNote)
	$('.startlist').on('click', -> startList($(this)))

	$('.folders').on('click', toggleFolderList)
	$('.newfolder').on('click', -> $(this).siblings('*').show())
	$('.confirmfolder').on('click', createFolder)

	$('.note .title').focus()