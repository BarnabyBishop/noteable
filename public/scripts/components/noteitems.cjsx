React = require 'react'
List = require './list.cjsx'
TextItem = require './textitem.cjsx'


NoteItems = React.createClass
	# getInitialState: ->
	# 	: ''
	# 	text: ''

	# componentDidMount: ->		
	# 	@setState 
	# 		title: @props.title
	# 		text: @props.text
	# 		position: @props.position
	# 		id: @props.id

	render: ->
		noteId = @props.noteid
		items = @props.items
		type = if items.length > 1 then 'multiple' else 'full'

		createItem = (item) ->
			if item.items
				<List key={item.position} type={type} title={item.title} position={item.position} items={item.items} />
			else
				<TextItem key={item.position} type={type} id={noteId} title={item.title} position={item.position} text={item.text} />

		<div>{items.map(createItem)}</div>

module.exports = NoteItems
