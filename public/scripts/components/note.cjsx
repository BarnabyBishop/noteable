React = require 'react'
NoteItems = require './noteitems.cjsx'

Note = React.createClass
	getInitialState: ->
		note: @props.note

	# componentDidMount: ->		
	# 	@setState 
	# 		title: @props.title
	# 		text: @props.text
	# 		position: @props.position
	# 		id: @props.id

	
	render: ->
		note = @props.note
		items = [].concat(note.texts, note.lists)

		<NoteItems noteid={note._id} items={items} />

module.exports = Note
