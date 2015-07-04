React = require 'react'
ListItem = require './ListItem.cjsx'
List = React.createClass
	render: ->
		createItem = (item) ->
			<ListItem text={item.text} checked={item.checked} />

		<div>
			<div>{@props.title}</div>
			{@props.items.map(createItem)}
		</div>


module.exports = List