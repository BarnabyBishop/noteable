React = require 'react'

# class BaseClass
# 	someFunction: ->
# 		alert 'yay'

# class DerivedClass extends BaseClass
# 	@nonFunction: ->
# 		alert 'expected'

# blah = new DerivedClass()

# blah.nonFunction()
# blah.someFunction()

class NoteList extends React.Component

	render: ->
		addItem = (note) ->
			<div id='notelist_#{note._id}'>#{note.title}</div>

		<div className="notelist">
			{@props.notes.map(addItem)}
		</div>

module.exports = NoteList