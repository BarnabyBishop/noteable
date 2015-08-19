React = require 'react'
NoteItems = require './NoteItems.cjsx'

Note = React.createClass
	render: ->
		<NoteItems note={@props.selectedNote} />

module.exports = Note
