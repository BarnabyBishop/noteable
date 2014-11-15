(function() {
  $(function() {
    var addFolderToList, addNoteToList, createFolder, createNote, deleteNote, editAmount, editFolder, editNoteField, editTimer, folders, notes, saveFolder, saveNote, selectFolder, selectNote, setValue;
    notes = {};
    folders = {};
    editAmount = 0;
    editTimer = false;
    selectNote = function(element) {
      var note;
      $('.notelist .selected').removeClass('selected');
      element.addClass('selected');
      note = notes[element.attr('data-id')];
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
    editNoteField = function(control, value) {
      var field, id;
      id = control.attr('data-id');
      if (!id) {
        id = createNote();
      }
      field = control.attr('data-field');
      notes[id][field] = value;
      setValue($("[data-field=" + field + "][data-id=" + id + "]").not(control), value);
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
      node = $("<div data-id='" + note._id + "' data-field='title'>" + note.title + "</div>");
      $('.notelist').append(node);
      return node.click(function() {
        return selectNote($(this));
      });
    };
    createNote = function() {
      var id;
      id = uuid.v4();
      notes[id] = {
        _id: id,
        title: '',
        path: $('.currentfolder').attr('data-current-path'),
        deleted: false
      };
      $('.note .title').attr('data-id', id);
      $('.note .text').attr('data-id', id);
      addNoteToList(notes[id]);
      return id;
    };
    deleteNote = function() {
      var id;
      id = $('.note .title').attr('data-id');
      if (id) {
        return $.ajax({
          type: 'POST',
          url: '/deletenote',
          data: {
            _id: id
          }
        });
      }
    };
    addFolderToList = function(folder) {
      var node;
      node = $("<div data-id='" + folder._id + "' data-path=" + folder.path + " class='folder' data-type='folder' data-field='name'><span class='icon fa fa-folder-o'></span><div data-id='" + folder._id + "'>" + (folder.name != null ? folder.name : void 0) + "</div></div>");
      $('.folderlist .panel .newfolder').before(node);
      return node.click(function() {
        return selectFolder($(this));
      });
    };
    selectFolder = function(folder) {
      var folderPath, note, _results;
      folderPath = folder.attr('data-path');
      $('.currentfolder').attr('data-current-path', folderPath);
      $('.notelist').empty();
      _results = [];
      for (note in notes) {
        if (notes[note].path === folderPath) {
          _results.push(addNoteToList(notes[note]));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    editFolder = function(control, value) {
      var editFolderTimer, id;
      id = control.attr('data-id');
      folders[id].name = value;
      if (editFolderTimer) {
        clearTimeout(editFolderTimer);
      }
      return editFolderTimer = setTimeout((function() {
        return saveFolder(id);
      }), 500);
    };
    createFolder = function() {
      var folderName, id;
      folderName = $('.foldername').val();
      if (folderName) {
        id = uuid.v4();
        folders[id] = {
          _id: id,
          name: folderName,
          path: ',' + folderName + ',',
          deleted: false
        };
        saveFolder(id);
        addFolderToList(folders[id]);
      }
      $('.foldername').text('').hide();
      return $('.confirmfolder').hide();
    };
    saveFolder = function(id) {
      return $.ajax({
        type: 'POST',
        url: '/savefolder',
        data: folders[id]
      });
    };
    $.ajax({
      url: "/getfolders"
    }).then(function(data) {
      return data.forEach(function(folder) {
        folders[folder._id] = folder;
        return addFolderToList(folder);
      });
    });
    $.ajax({
      url: "/getnotes"
    }).then(function(data) {
      var currentPath;
      currentPath = $('.currentfolder').attr('data-current-path');
      return data.forEach(function(note) {
        notes[note._id] = note;
        if (note.path === currentPath) {
          return addNoteToList(note);
        }
      });
    });
    $('.note .title').on('input', function() {
      return editNoteField($(this), this.value);
    });
    $('.note .text').on('input', function() {
      return editNoteField($(this), this.value);
    });
    $('.newnote').on('click', createNote);
    $('.deletenote').on('click', deleteNote);
    $('.folders').on('click', function() {
      return $('.folderlist').find('.panel').toggle();
    });
    $('.newfolder').on('click', function() {
      return $(this).siblings('*').show();
    });
    return $('.confirmfolder').on('click', createFolder);
  });

}).call(this);
