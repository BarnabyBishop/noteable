(function() {
  $(function() {
    var addNoteToList, editAmount, editField, editTimer, notes, saveNote, selectNote, setValue;
    notes = {};
    editAmount = 0;
    editTimer = false;
    selectNote = function(element) {
      var note;
      $('.note-list .selected').removeClass('selected');
      element.addClass('selected');
      note = notes[element.attr('data-id')];
      $('.note .title').attr('test', note._id);
      $('.note .title').val(note.title).attr('data-id', note._id);
      return $('.note .text').val(note.text).attr('data-id', note._id);
    };
    setValue = function(elements, value) {
      return elements.each(function() {
        var element;
        element = $(this);
        if (element.is("input") || element.is("textarea")) {
          return element.value(value);
        } else {
          return element.text(value);
        }
      });
    };
    editField = function(control, value) {
      var id, newNote, type;
      id = control.attr('data-id');
      if (!id) {
        newNote = true;
        id = uuid.v4();
        notes[id] = {
          _id: id
        };
        $('.note .title').attr('data-id', id);
        $('.note .text').attr('data-id', id);
      }
      type = control.attr('data-type');
      notes[id][type] = value;
      if (newNote) {
        addNoteToList(notes[id]);
      } else {
        setValue($("[data-type=" + type + "][data-id=" + id + "]").not(control), value);
      }
      if (editTimer) {
        clearTimeout(editTimer);
      }
      if (++editAmount === 50) {
        editAmount = 0;
        return saveNote(id);
      } else {
        return editTimer = setTimeout((function() {
          return saveNote(id);
        }), 500);
      }
    };
    saveNote = function(id) {
      return $.ajax({
        type: 'POST',
        url: '/savenote',
        data: notes[id]
      });
    };
    addNoteToList = function(note) {
      var node;
      node = $("<div data-id='" + note._id + "' data-type='title'>" + note.title + "</div>");
      $('.note-list').append(node);
      return node.click(function() {
        return selectNote($(this));
      });
    };
    $.ajax({
      url: "/notes"
    }).done(function(data) {
      return data.forEach(function(note) {
        notes[note._id] = note;
        return addNoteToList(note);
      });
    });
    $('.note .title').on('input', function() {
      return editField($(this), this.value);
    });
    return $('.note .text').on('input', function() {
      return editField($(this), this.value);
    });
  });

}).call(this);
