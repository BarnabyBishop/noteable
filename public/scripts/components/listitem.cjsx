React = require 'react'

ListItem = React.createClass
	render: ->
		<div key={this.props.position}>{this.props.checked}</div>
		<div key={this.props.position}>{this.props.text}</div>

module.exports = ListItem
