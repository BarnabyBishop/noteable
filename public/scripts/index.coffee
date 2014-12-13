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

		$('.list').empty()
		if note.list?.length
			renderList($('.list'), note.list)

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
		$.ajax(
			type: 'POST',
			url: '/savenote',
			contentType: 'application/json',
			data: JSON.stringify(notes[id])

		)

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

		$('.note .list').empty()

	createNote = ->
		$('.list').empty()
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

	addFolderToList = (folder) ->
		node = $("<div data-id='#{folder._id}' data-path='#{folder.path}' class='folder' data-type='folder' data-field='name'><i class='icon ion-ios7-bookmarks-outline'></i><div data-id='#{folder._id}'>#{folder.name if folder.name?}</div></div>")
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
		$('.list').empty()
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
		$('.note .title').attr('data-id', '')
		$('.note .text').attr('data-id', '')

	startList = (button) ->
		list = button.siblings('.list')
		renderList(list)
		list.find('.listtext').focus()

	renderList = (container, list) ->
		listTemplate = nunjucks.render('listitem.html', { list: list })
		container.append(listTemplate)
		bindList(container)
		if (list)
			$('.note .text').attr('tabindex', list.length)

	bindList = (container) ->
		# remove all handlers to avoid double binding
		container.find('.listtext')
				 .off()
				 .on('keypress', (e) -> insertItemAfter($(this), e))
				 .on('input', -> editListItem($(this)))
		container.find('.listcheckbox').off().on('click', -> checkListItem($(this).parent()))
		container.find('.listclose').off().on('click', -> deleteListItem($(this).parent()))
		container.find('.listmoveup').off().on('click', -> moveListItem($(this).parent(), -1))
		container.find('.listmovedown').off().on('click', -> moveListItem($(this).parent(), 1))

	insertItemAfter = (inputControl, e) ->
		if e.which == 13
			e.preventDefault()
			noteId = $('.note .title').attr('data-id')
			item = inputControl.parent()
			itemIndex = parseInt(item.attr('data-index'))
			notes[noteId].list.splice(itemIndex + 1, 0, { text: '', checked: false })

			newItem = item.clone()
			item.after(newItem)

			newItem.find('.listtext').text('').focus()

			newItem.removeClass('checked')
			newItem.find('.listcheckbox')
				.removeClass('ion-ios7-checkmark-outline')
				.addClass('ion-ios7-circle-outline')

			resetListIndex(newItem.parent())
			bindList(newItem.parent())

	editListItem = (input) ->
		noteId = $('.note .title').attr('data-id')
		if not noteId
			noteId = createNote()

		if not notes[noteId].list
			notes[noteId].list = []

		list = notes[noteId].list
		listItem = input.parent()
		if listItem.attr('data-index')
			listIndex = parseInt(listItem.attr('data-index'))
		else
			listIndex = list.length
			listItem.attr('data-index', listIndex)
		console.log listIndex, list
		if list.length < (listIndex + 1)
			list.push({ text: input.text(), checked: false })
			renderList(listItem.parent())
		else
			list[listIndex].text = input.text()
		setSaveTimer(noteId)

	checkListItem = (control) ->
		noteId = $('.note .title').attr('data-id')

		listIndex = control.attr('data-index')
		if not noteId or not notes[noteId].list or not notes[noteId].list[listIndex]
			return

		notes[noteId].list[listIndex].checked = !notes[noteId].list[listIndex].checked

		control.toggleClass('checked')
		control.find('.listcheckbox')
				.toggleClass('ion-ios7-checkmark-outline')
				.toggleClass('ion-ios7-circle-outline')

		setSaveTimer(noteId)

	deleteListItem = (control) ->
		noteId = $('.note .title').attr('data-id')

		listIndex = control.attr('data-index')
		if not noteId or not notes[noteId].list or not notes[noteId].list[listIndex]
			return

		notes[noteId].list.splice(listIndex, 1)

		control.remove()

		listContainer = control.closest('.list')
		resetListIndex(listContainer)

		setSaveTimer(noteId)

	moveListItem = (control, relativePosition) ->
		noteId = $('.note .title').attr('data-id')

		if not noteId or not notes[noteId].list
			return

		listIndex = parseInt(control.attr('data-index'))
		list = notes[noteId].list
		console.log list
		item = list.splice(listIndex, 1)
		list.splice(listIndex + relativePosition, 0, item[0])
		if (relativePosition > 0)
			control.insertAfter(control.next())
		else
			control.insertBefore(control.prev())

		listContainer = control.closest('.list')
		resetListIndex(listContainer)
		#listContainer.empty()
		# renderList(listContainer, list)

		setSaveTimer(noteId)


	resetListIndex = (container) ->
		index = 0
		container.find('.listitem').each ->
			$(this).attr('data-index', index++)
			$(this).find('.listtext').attr('tabindex', index + 2)
		$('.note .text').attr('tabindex', index + 2)

	setSaveTimer  = (id) ->
		# If the user has stopped typing for 1 second Or made over 50 changes save
		if editTimer
			clearTimeout(editTimer)
		if ++editAmount == 50
			editAmount = 0
			saveNote(id)
		else
			editTimer = setTimeout((-> saveNote(id)), 500)

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
	$('.startlist').on('click', -> startList($(this)))

	$('.folders').on('click', toggleFolderList)
	$('.newfolder').on('click', -> $(this).siblings('*').show())
	$('.confirmfolder').on('click', createFolder)

	$('.note .title').focus()