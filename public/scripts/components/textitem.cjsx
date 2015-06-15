React = require './libs/react'
NoteStore = require './stores/notestore.coffee'

noteStore = new NoteStore()

notes = {}
editAmount = 0
editTimer = false
currentPath = ''

class TextItem extends extends React.Component
    render: ->
        <div class="note">
            <input type="text" class="title" placeholder="Title" data-field="title" tabindex="1">
            <textarea name="" id="" cols="30" rows="10" class="text" placeholder="Note" data-field="text" tabindex="2"></textarea>
        </div>
