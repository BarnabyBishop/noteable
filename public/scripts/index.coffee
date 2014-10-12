$ ->
	notes = {}
	editAmount = 0
	editTimer = false

	selectNote = (element) ->
		$('.note-list .selected').removeClass('selected')
		element.addClass('selected')

		note = notes[element.data('id')]
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
		id = control.data('id')
		type = control.data('type')
		notes[id][type] = value
		setValue($("[data-type=#{type}][data-id=#{id}]").not(control), value)

		# If the user has stopped typing for 1 second Or made over 50 changes save
		if editTimer
			clearTimeout(editTimer)
		if (++editAmount == 50)
			editAmount = 0
			saveNote(id)
		else
			editTimer = setTimeout((-> saveNote(id)), 1000)

	saveNote = (id) ->
		$.ajax(
			type: 'POST',
			url: '/savenote',
			data: notes[id]
		)

	# Load notes from serbe
	$.ajax(url: "/notes")
	.done(
		(data) ->
			data.forEach(
				(note) ->
					notes[note._id] = note
					node = $("<div data-id='#{note._id}' data-type='title'>#{note.title}</div>")
					$('.note-list').append(node)
					node.click( ->
						selectNote($(this))
					)
			)
	)

	# prepare inputs for editing
	$('.note .title').on('input', -> editField($(this), this.value))
	$('.note .text') .on('input', -> editField($(this), this.value))