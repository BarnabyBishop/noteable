React = require 'react'
Note = require './Note.cjsx'
NoteList = require './NoteList.cjsx'
NoteControls = require './NoteControls.cjsx'

class App extends React.Component

	render: ->
		<div>
			<div className="notelist-container">
				<div className="folderlist">
					<button className="folders">
						<i className="note-button icon-button fa fa-book"></i>
						<span className="currentfolder" data-current-path=""></span>
					</button>
					<div className="panel">
						<button className="icon-button fa fa-plus newfolder"></button>
						<div className="note-button folder-home"><i className="icon-button fa fa-home"></i></div>
						<div className="note-button folder-up"><i className="icon-button fa fa-level-up"></i></div>
						<input type="text" placeholder="New Folder" className="foldername textbox" />
						<button className="confirmfolder icon-button fa fa-check-circle-o"></button>
					</div>
				</div>
				<NoteList notes={@props.notes} currentPath={@props.currentPath} />
			</div>
			<div className="note-container">
				<NoteControls noteid={@props.selectedNote?._id} currentPath={@props.currentPath} />
				<Note note={@props.selectedNote} />
			</div>
		</div>
module.exports = App