React = require 'react'
NoteStore = require '../stores/notestore.coffee'

noteStore = new NoteStore()

notes = {}
editAmount = 0
editTimer = false
currentPath = ''

TextItem = React.createClass
	getInitialState: ->
		title: ''
		text: ''

	componentDidMount: ->		
		@setState 
			title: @props.title
			text: @props.text
			position: @props.position
			id: @props.id

	handleTitleChange: (event) ->
		title = event.target.value
		@setState(title: title)
		noteStore.updateTextTitle(@state.id, @state.position, title)

	handleTextChange: (event) ->
		text = event.target.value
		@setState(text: text)
		noteStore.updateText(@state.id, @state.position, text)

	render: ->
		<div key={@props.id} position={@props.position} className="note">
			<input value={@state.title} onChange={@handleTitleChange} type="text" className="title" placeholder="Title" tabIndex="1" />
			<textarea value={@state.text} onChange={@handleTextChange} cols="30" rows="10" className="text" placeholder="Note" tabIndex="2"></textarea>
		</div>

module.exports = TextItem
