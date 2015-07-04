React = require 'react'

ListItem = React.createClass
	render: ->
		<div key={'listitem_checked_' + this.props.position}>{this.props.checked}</div>
		<div key={'listitem_text_' + this.props.position}>{this.props.text}</div>

module.exports = ListItem
