React = require 'react'

ListItem = React.createClass
	render: ->
		<div key={'listitem_checked_' + @props.position}>{@props.checked}</div>
		<div key={'listitem_text_' + @props.position}>{@props.text}</div>

module.exports = ListItem
