React = require 'react'
noteStore = require '../stores/NoteStore.coffee'

notes = {}
editAmount = 0
editTimer = false
currentPath = ''

TextItem = React.createClass
	# getInitialState: ->
	# 	title: ''
	# 	text: ''

	# componentDidMount: ->
	# 	@setState
	# 		title: @props.title
	# 		text: @props.text
	# 		position: @props.position
	# 		id: @props.id

	handleTitleChange: (event) ->
		title = event.target.value
		# @setState(title: title)
		noteStore.updateTextTitle(@props.id, @props.position, title)

	handleTextChange: (event) ->
		text = event.target.value
		# @setState(text: text)
		noteStore.updateText(@props.id, @props.position, text)

	render: ->
		<div key={'textnode_' + @props.id + '_' + @props.position} position={@props.position} className={'note ' + @props.type}>
			<input value={@props.title} onChange={@handleTitleChange} type="text" className="title" placeholder="Title" tabIndex="1" />
			<textarea value={@props.text} onChange={@handleTextChange} cols="30" rows="10" className="text" placeholder="Note" tabIndex="2"></textarea>
		</div>

module.exports = TextItem
