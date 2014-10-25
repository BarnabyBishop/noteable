$ ->
	notes = {}
	folders = {}
	editAmount = 0
	editTimer = false

	selectNote = (element) ->
		$('.note-list .selected').removeClass('selected')
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
		if (++editAmount == 50)
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
		$('.note-list').append(node)
		node.click( ->
			selectNote($(this))
		)


	createNote = ->
		id = uuid.v4()
		notes[id] =
			_id: id
			title: ''
			deleted: false
		$('.note .title').attr('data-id', id)
		$('.note .text').attr('data-id', id)
		addNoteToList(notes[id])
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
		node = $("<div data-id='#{folder._id}' data-type='folder' data-field='name'><span class='typcn typcn-folder'></span><input type='text' data-id='#{folder._id}' value='#{folder.name if folder.name?}' /></div>")
		$('.note-list').append(node)
		node.click( ->
			selectFolder($(this))
		)
		node.find('input').on('input', -> editFolder($(this), this.value))

	selectFolder = ->
		s = 'todo'

	editFolder = (control, value) ->
		id = control.attr('data-id')

		folders[id].name = value
		# If the user has stopped typing for 1 second Or made over 50 changes save
		if editFolderTimer
			clearTimeout(editFolderTimer)
		editFolderTimer = setTimeout((-> saveFolder(id)), 500)

	createFolder = ->
		id = uuid.v4()
		folders[id] =
			_id: id
			name: ''
			parent: ''
			deleted: false

		addFolderToList(folders[id])
		return id

	saveFolder = (id) ->
		$.ajax(
			type: 'POST',
			url: '/savefolder',
			data: folders[id]
		)

	# Load notes from server
	$.ajax(url: "/getfolders")
	.then(
		(data) ->
			data.forEach(
				(folder) ->
					folders[folder._id] = folder
					addFolderToList(folder)
			)
			$.ajax(url: "/getnotes")
	)
	.then(
		(data) ->
			data.forEach(
				(note) ->
					notes[note._id] = note
					addNoteToList(note)
			)
	)

	# prepare inputs for editing
	$('.note .title').on('input', -> editNoteField($(this), this.value))
	$('.note .text') .on('input', -> editNoteField($(this), this.value))

	$('.newfolder').on('click', createFolder)
	$('.newnote').on('click', createNote)
	$('.deletenote').on('click', deleteNote)