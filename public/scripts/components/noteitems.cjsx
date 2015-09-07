React = require 'react'
List = require './List.cjsx'
TextItem = require './TextItem.cjsx'

NoteItems = React.createClass
	render: ->
		if @props.note
			@renderItems()
		else
			@renderEmpty()

	renderItems: ->
		noteId = @props.note._id

		items = @props.note.texts || []
		if @props.note.lists
			items = items.concat(@props.note.lists)

		type = if items?.length > 1 then 'multiple' else 'full'

		createItem = (item) ->
			if item?.items
				<List key={'noteId_items_' + item.position} type={type} title={item.title} position={item.position} items={item.items} />
			else
				<TextItem key={'noteId_items_' + item.position} type={type} id={noteId} title={item.title} position={item.position} text={item.text} />

		if items?.length
			<div key={noteId + '_items'}>{items.map(createItem)}</div>
		else
			<div key={noteId + '_items'}></div>

	renderEmpty: ->
		<div>Please select a note.</div>

module.exports = NoteItems
