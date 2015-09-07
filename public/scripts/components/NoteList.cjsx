React = require 'react'
noteStore = require '../stores/NoteStore.coffee'

class NoteList extends React.Component

	handleClick: (noteId) ->
		noteStore.updateSelectedNoteId(noteId)

	render: ->
		addItem = (note) =>
			boundClick = @handleClick.bind(this, note._id);
			# use the title from the first object. todo use position
			title = note.texts?[0]?.title or note.lists?[0]?.title or ''
			<div key={'notelist_' + note._id} onClick={boundClick}>{title}</div>

		<div className="notelist">
			{@props.notes.map(addItem)}
		</div>

module.exports = NoteList