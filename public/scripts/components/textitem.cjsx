React = require './libs/react'
NoteStore = require './stores/notestore.coffee'

noteStore = new NoteStore()

notes = {}
editAmount = 0
editTimer = false
currentPath = ''

class TextItem extends extends React.Component
	getInitialState: ->
		title: @props.title
		text: @props.text

	handleTitleChange: (event) ->
		@setState(title: event.target.value)
	
	handleTextChange: (event) ->
		@setState(text: event.target.value)

	render: ->
		title = @state.title
		text = @state.text
		<div className="note">
			<input value={@title} onChange={@handleTitleChange} type="text" className="title" placeholder="Title" tabIndex="1" />
			<textarea value={@text} onChange={@handleTextChange} cols="30" rows="10" className="text" placeholder="Note" tabIndex="2"></textarea>
		</div>

module.exports = TextItem
