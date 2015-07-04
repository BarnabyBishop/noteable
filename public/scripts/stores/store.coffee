class Store
	constructor: ->
		@changeListeners = []
		@eventListeners = {}

	notifyChange: (name) ->
		if @eventListeners[name]
			@eventListeners[name].forEach (fn) ->
				fn()
				return
		@changeListeners.forEach (fn) ->
			fn()
			return
		return

	addChangeListener: (name, fn) ->
		if arguments.length == 1
			fn = name
			name = null

		if name
			if !@eventListeners[name]
				@eventListeners[name] = []
			@eventListeners[name].push fn
		else
			@changeListeners.push fn
		return

	removeChangeListener: (name, fn) ->
		if arguments.length == 1
			fn = name
			name = null

		if name
			if @eventListeners[name]
				@eventListeners[name] = @eventListeners[name].filter((i) ->
					fn != i
				)
		else
			@changeListeners = @changeListeners.filter((i) ->
				fn != i
			)
		return

	extend: ->
		i = 0
		while i < arguments.length
			source = arguments[i]
			for key of source
				if source.hasOwnProperty(key)
					@[key] = source[key]
			i++
		return this


# @extend.apply this, arguments

module.exports = Store