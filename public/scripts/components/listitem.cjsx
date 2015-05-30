React = require '../libs/react'

ListItem = React.createClass
	render: ->
		return <div>{this.props.text}</div>

module.exports = ListItem
