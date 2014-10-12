(function() {
  $(function() {
    var editAmount, editField, editTimer, notes, saveNote, selectNote, setValue;
    notes = {};
    editAmount = 0;
    editTimer = false;
    selectNote = function(element) {
      var note;
      $('.note-list .selected').removeClass('selected');
      element.addClass('selected');
      note = notes[element.data('id')];
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
      var id, type;
      id = control.data('id');
      type = control.data('type');
      notes[id][type] = value;
      setValue($("[data-type=" + type + "][data-id=" + id + "]").not(control), value);
      if (editTimer) {
        clearTimeout(editTimer);
      }
      if (++editAmount === 50) {
        editAmount = 0;
        return saveNote(id);
      } else {
        return editTimer = setTimeout((function() {
          return saveNote(id);
        }), 1000);
      }
    };
    saveNote = function(id) {
      return $.ajax({
        type: 'POST',
        url: '/savenote',
        data: notes[id]
      });
    };
    $.ajax({
      url: "/notes"
    }).done(function(data) {
      return data.forEach(function(note) {
        var node;
        notes[note._id] = note;
        node = $("<div data-id='" + note._id + "' data-type='title'>" + note.title + "</div>");
        $('.note-list').append(node);
        return node.click(function() {
          return selectNote($(this));
        });
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
