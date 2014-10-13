$ ->
	notes = {}
	editAmount = 0
	editTimer = false

	selectNote = (element) ->
		$('.note-list .selected').removeClass('selected')
		element.addClass('selected')

		note = notes[element.attr('data-id')]
		$('.note .title').attr('test', note._id)
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

	editField = (control, value) ->
		id = control.attr('data-id')
		if not id
			newNote = true
			id = uuid.v4()
			notes[id] =
				_id: id
			$('.note .title').attr('data-id', id)
			$('.note .text').attr('data-id', id)

		type = control.attr('data-type')
		notes[id][type] = value

		if newNote
			addNoteToList(notes[id])
		else
			setValue($("[data-type=#{type}][data-id=#{id}]").not(control), value)

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
		node = $("<div data-id='#{note._id}' data-type='title'>#{note.title}</div>")
		$('.note-list').append(node)
		node.click( ->
			selectNote($(this))
		)

	# Load notes from serbe
	$.ajax(url: "/notes")
	.done(
		(data) ->
			data.forEach(
				(note) ->
					notes[note._id] = note
					addNoteToList(note)
			)
	)

	# prepare inputs for editing
	$('.note .title').on('input', -> editField($(this), this.value))
	$('.note .text') .on('input', -> editField($(this), this.value))