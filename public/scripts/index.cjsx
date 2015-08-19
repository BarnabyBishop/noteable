$ = require 'jquery'
uuid = require 'uuid'
App = require './components/App.cjsx'
React = require 'react'
noteStore = require './stores/NoteStore.coffee'

notes = {}
folders = {}
editAmount = 0
editTimer = false
currentPath = ''

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

notesUpdated = ->
	loadNotes ->
		render()

loadNotes = (cb) ->
	noteStore.getNotes (data) ->
		notes = data
		unless Array.isArray notes
			notes = [notes]

		cb()

loadFolders = ->
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


	$('.folders').on('click', toggleFolderList)
	$('.newfolder').on('click', -> $(this).siblings('*').show())
	$('.confirmfolder').on('click', createFolder)

render = ->
	React.render <App notes={notes} path={currentPath} />,
		document.getElementById('app')

init = ->
	# Get current route/path and set current folder
	if window.location.pathname and window.location.pathname isnt '/'
		currentPath = decodeURI(window.location.pathname).replace(/\//g, ',,')
		currentPath = currentPath.substring(1) + ','

	loadNotes ->
		console.log notes
		render()
		loadFolders()
		noteStore.addChangeListener notesUpdated


module.exports = init