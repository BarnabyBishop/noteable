uuid = require './uuid'
nunjucks = require './nunjucks'
templates = require './templates'

exports = module.exports

exports.startList = (button) ->
	list = button.siblings('.list')
	renderList(list)
	list.find('.listtext').focus()

exports.renderList = (container, list) ->
	listTemplate = nunjucks.render('listitem.html', { list: list })
	container.append(listTemplate)
	bindList(container)
	if (list)
		$('.note .text').attr('tabindex', list.length)

exports.bindList = (container) ->
	# remove all handlers to avoid double binding
	container.find('.listtext')
			 .off()
			 .on('keypress', (e) -> insertItemAfter($(this), e))
			 .on('input', -> editListItem($(this)))
	container.find('.listcheckbox').off().on('click', -> checkListItem($(this).parent()))
	container.find('.listclose').off().on('click', -> deleteListItem($(this).parent()))
	container.find('.listmoveup').off().on('click', -> moveListItem($(this).parent(), -1))
	container.find('.listmovedown').off().on('click', -> moveListItem($(this).parent(), 1))

exports.insertItemAfter = (inputControl, e) ->
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

exports.editListItem = (input) ->
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

exports.checkListItem = (control) ->
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

exports.deleteListItem = (control) ->
	noteId = $('.note .title').attr('data-id')

	listIndex = control.attr('data-index')
	if not noteId or not notes[noteId].list or not notes[noteId].list[listIndex]
		return

	notes[noteId].list.splice(listIndex, 1)

	control.remove()

	listContainer = control.closest('.list')
	resetListIndex(listContainer)

	setSaveTimer(noteId)

exports.moveListItem = (control, relativePosition) ->
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


exports.resetListIndex = (container) ->
	index = 0
	container.find('.listitem').each ->
		$(this).attr('data-index', index++)
		$(this).find('.listtext').attr('tabindex', index + 2)
	$('.note .text').attr('tabindex', index + 2)