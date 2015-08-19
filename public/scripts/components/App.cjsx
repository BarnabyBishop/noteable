React = require 'react'
Note = require './Note.cjsx'
NoteList = require './NoteList.cjsx'
NoteControls = require './NoteControls.cjsx'

# class BaseClass
# 	someFunction: ->
# 		alert 'yay'

# class DerivedClass extends BaseClass
# 	@nonFunction: ->
# 		alert 'expected'

# blah = new DerivedClass()

# blah.nonFunction()
# blah.someFunction()

class App extends React.Component

	render: ->
		<div>
			<div className="notelist-container">
				<div className="folderlist">
					<button className="folders">
						<i className="icon-button fa fa-book"></i>
						<span className="currentfolder" data-current-path=""></span>
					</button>
					<div className="panel">
						<button className="icon-button fa fa-plus newfolder"></button>
						<input type="text" placeholder="New Folder" className="foldername textbox">
						<button className="confirmfolder icon-button fa fa-check-circle-o"></button>
					</div>
				</div>
				<NoteList notes={@props.notes} />
			</div>
			<div className="note-container">
				<NoteControls noteid={@props.selectedNote?._id} path={@props.path} />
				<Note note={@props.selectedNote} />
			</div>
		</div>
module.exports = App