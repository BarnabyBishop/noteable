React = require 'react'
noteStore = require '../stores/NoteStore.coffee'

NoteControls = React.createClass

	addTextNode: (event) ->
		noteStore.addTextNode(@props.noteid)

	addList: (event) ->
		noteStore.addList(@props.noteid)

	addNote: (event) ->
		noteStore.addNote(@props.currentPath)

	deleteNote: (event) ->
		noteStore.deleteNote(@props.noteid)

	render: ->
		<div key={@props.noteid + '_controls'} className="note-control-container">
			<div className="note-add-buttons">
				<button className="note-button note-button-addlist fa fa-list" onClick={@addList} />
				<button className="note-button note-button-addtext fa fa-file-text-o" onClick={@addTextNode} />
				<button className="note-button note-button-newnote fa fa-pencil" onClick={@addNote}></button>
			</div>
			<button className="note-button note-button-deletenote fa fa-trash-o" onClick={@deleteNote}></button>
			<button className="note-button note-button-savingnote fa fa-save-o"></button>
		</div>

module.exports = NoteControls
