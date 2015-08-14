React = require 'react'
NoteItems = require './NoteItems.cjsx'
NoteControls = require './NoteControls.cjsx'

Note = React.createClass
	render: ->
		note = @props.note

		<div>
			<NoteControls noteid={note._id} path={@props.path} />
			<NoteItems noteid={note._id} />
		</div>

module.exports = Note
