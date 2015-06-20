React = require '../libs/react'
ListItem = require './listitem.cjsx'
List = React.createClass
	render: ->
		createItem = (item) ->
			console.log 'blah'
			<ListItem text={item.text} checked={item.checked} />

		<div>
			<div>{@props.title}</div>
			{@props.items.map(createItem)}
		</div>


module.exports = List