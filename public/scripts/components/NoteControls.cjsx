React = require 'react'
noteStore = require '../stores/NoteStore.coffee'

NoteControls = React.createClass

	addTextNode: (event) ->
		noteStore.addTextNode(@props.noteid)

	addList: (event) ->
		noteStore.addList(@props.noteid)

	render: ->
		<div key={@props.noteid + '_controls'} className="note-control-container">
			<button onClick={@addTextNode}" className="note-button fa fa-file-text-o" />
			<button onClick={@addList} className="note-button fa fa-list" />
		</div>

module.exports = NoteControls
