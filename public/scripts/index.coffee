$ ->
	notes = {}
	folders = {}
	editAmount = 0
	editTimer = false

	selectNote = (element) ->
		$('.notelist .selected').removeClass('selected')
		element.addClass('selected')

		note = notes[element.attr('data-id')]
		$('.note .title').val(note.title).attr('data-id', note._id)
		$('.note .text').val(note.text).attr('data-id', note._id)

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

		# If the user has stopped typing for 1 second Or made over 50 changes save
		if editTimer
			clearTimeout(editTimer)
		if ++editAmount == 50
			editAmount = 0
			saveNote(id)
		else
			editTimer = setTimeout((-> saveNote(id)), 500)

	saveNote = (id) ->
		$.ajax(
			type: 'POST',
			url: '/savenote',
			data: notes[id]
		)

	addNoteToList = (note) ->
		node = $("<div data-id='#{note._id}' data-field='title'>#{note.title}</div>")
		$('.notelist').append(node)
		node.click( ->
			selectNote($(this))
		)


	createNote = ->
		id = uuid.v4()
		notes[id] =
			_id: id
			title: ''
			path: $('.currentfolder').attr('data-current-path')
			deleted: false
		$('.note .title').attr('data-id', id)
		$('.note .text').attr('data-id', id)
		addNoteToList(notes[id])
		clearInputs()
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

	addFolderToList = (folder) ->
		node = $("<div data-id='#{folder._id}' data-path='#{folder.path}' class='folder' data-type='folder' data-field='name'><span class='icon fa fa-folder-o'></span><div data-id='#{folder._id}'>#{folder.name if folder.name?}</div></div>")
		$('.folderlist .panel .newfolder').before(node)
		node.click( ->
			selectFolder($(this))
		)

	selectFolder = (folderElement)->
		folderPath = folderElement.attr('data-path')
		folderId = folderElement.attr('data-id')
		$('.currentfolder')
			.attr('data-current-path', folderPath)
			.text(folders[folderId].name)
		$('.notelist').empty()
		for note of notes
			if notes[note].path is folderPath
				addNoteToList(notes[note])
		toggleFolderList()
		clearInputs()

	editFolder = (control, value) ->
		id = control.attr('data-id')

		folders[id].name = value
		# If the user has stopped typing for 1 second Or made over 50 changes save
		if editFolderTimer
			clearTimeout(editFolderTimer)
		editFolderTimer = setTimeout((-> saveFolder(id)), 500)

	createFolder = ->
		folderName = $('.foldername').val()
		if folderName
			id = uuid.v4()
			folders[id] =
				_id: id
				name: folderName
				path: ',' + folderName + ','
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

	makeList = ->
		# todo


	# Load notes from server
	$.ajax(url: "/getfolders")
	.then(
		(data) ->
			folders[''] =
				_id: ''
				name: '/'
				path: ''
			addFolderToList(folders[''])
			data.forEach(
				(folder) ->
					folders[folder._id] = folder
					addFolderToList(folder)
			)
	)
	$.ajax(url: "/getnotes")
	.then(
		(data) ->
			currentPath = $('.currentfolder').attr('data-current-path')
			data.forEach(
				(note) ->
					notes[note._id] = note
					if note.path is currentPath
						addNoteToList(note)
			)
	)

	# prepare inputs for editing
	$('.note .title').on('input', -> editNoteField($(this), this.value))
	$('.note .text') .on('input', -> editNoteField($(this), this.value))
	$('.newnote').on('click', createNote)
	$('.deletenote').on('click', deleteNote)
	$('.makelist').on('click', makeList)

	$('.folders').on('click', toggleFolderList)
	$('.newfolder').on('click', -> $(this).siblings('*').show())
	$('.confirmfolder').on('click', createFolder)

	$('.note .title').focus()