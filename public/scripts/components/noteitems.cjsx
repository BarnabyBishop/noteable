React = require 'react'
List = require './List.cjsx'
TextItem = require './TextItem.cjsx'
NoteStore = require '../stores/NoteStore.coffee'

noteStore = new NoteStore()

NoteItems = React.createClass
	getInitialState: ->
		@getItemsState()

	getItemsState: ->
		items: noteStore.getItems(@props.noteid)

	updateItemsState: ->
		@setState @getItemsState()

	componentDidMount: ->
		noteStore.addChangeListener @updateItemsState

	componentWillUnmount: ->
		noteStore.removeChangeListener @updateItemsStateß

	render: ->
		noteId = @props.noteid
		items = @state.items
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

module.exports = NoteItems
