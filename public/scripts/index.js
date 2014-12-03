(function() {
  $(function() {
    var addFolderToList, addNoteToList, checkItem, clearInputs, createFolder, createNote, deleteItem, deleteNote, editAmount, editFolder, editListField, editNoteField, editTimer, folders, notes, renderList, saveFolder, saveNote, selectFolder, selectNote, setSaveTimer, setValue, startList, toggleFolderList;
    notes = {};
    folders = {};
    editAmount = 0;
    editTimer = false;
    selectNote = function(element) {
      var note, _ref;
      $('.notelist .selected').removeClass('selected');
      element.addClass('selected');
      note = notes[element.attr('data-id')];
      $('.note .title').val(note.title).attr('data-id', note._id);
      $('.note .text').val(note.text).attr('data-id', note._id);
      if ((_ref = note.list) != null ? _ref.length : void 0) {
        return renderList(note.list);
      } else {
        return $('.list').empty();
      }
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
      return setSaveTimer(id);
    };
    saveNote = function(id) {
      return $.ajax({
        type: 'POST',
        url: '/savenote',
        contentType: 'application/json',
        data: JSON.stringify(notes[id])
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
      clearInputs();
      $('.note .title').focus();
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
      node = $("<div data-id='" + folder._id + "' data-path='" + folder.path + "' class='folder' data-type='folder' data-field='name'><span class='icon fa fa-folder-o'></span><div data-id='" + folder._id + "'>" + (folder.name != null ? folder.name : void 0) + "</div></div>");
      $('.folderlist .panel .newfolder').before(node);
      return node.click(function() {
        return selectFolder($(this));
      });
    };
    selectFolder = function(folderElement) {
      var folderId, folderPath, note;
      folderPath = folderElement.attr('data-path');
      folderId = folderElement.attr('data-id');
      $('.currentfolder').attr('data-current-path', folderPath).text(folders[folderId].name);
      $('.notelist').empty();
      for (note in notes) {
        if (notes[note].path === folderPath) {
          addNoteToList(notes[note]);
        }
      }
      toggleFolderList();
      return clearInputs();
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
    toggleFolderList = function() {
      return $('.folderlist').find('.panel').toggle();
    };
    clearInputs = function() {
      $('.note .title').val('');
      return $('.note .text').val('');
    };
    startList = function() {
      return renderList();
    };
    renderList = function(list) {
      var listTemplate;
      listTemplate = nunjucks.render('list.html', {
        list: list
      });
      $('.list').html(listTemplate);
      $('.listtext').on('input', function() {
        return editListField($(this).parent(), this.value);
      });
      $('.checkbox').on('click', function() {
        return checkItem($(this).parent());
      });
      return $('.listclose').on('click', function() {
        return deleteItem($(this).parent());
      });
    };
    editListField = function(control, value) {
      var list, listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      if (!noteId) {
        noteId = createNote();
      }
      if (!notes[noteId].list) {
        notes[noteId].list = [];
      }
      listIndex = parseInt(control.attr('data-index'));
      list = notes[noteId].list;
      if (list.length < (listIndex + 1)) {
        list.push({
          text: value,
          checked: false
        });
      } else {
        list[listIndex].text = value;
      }
      return setSaveTimer(noteId);
    };
    checkItem = function(control) {
      var listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      listIndex = control.attr('data-index');
      if (!noteId || !notes[noteId].list || !notes[noteId].list[listIndex]) {
        return;
      }
      notes[noteId].list[listIndex].checked = !notes[noteId].list[listIndex].checked;
      control.toggleClass('checked');
      control.find('button').toggleClass('ion-ios7-checkmark-outline').toggleClass('ion-ios7-circle-outline');
      return setSaveTimer(noteId);
    };
    deleteItem = function(control) {
      var listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      listIndex = control.attr('data-index');
      if (!noteId || !notes[noteId].list || !notes[noteId].list[listIndex]) {
        return;
      }
      notes[noteId].list.splice(listIndex, 1);
      renderList(notes[noteId].list);
      return setSaveTimer(noteId);
    };
    setSaveTimer = function(id) {
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
    $.ajax({
      url: "/getfolders"
    }).then(function(data) {
      folders[''] = {
        _id: '',
        name: '/',
        path: ''
      };
      addFolderToList(folders['']);
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
    $('.startlist').on('click', startList);
    $('.folders').on('click', toggleFolderList);
    $('.newfolder').on('click', function() {
      return $(this).siblings('*').show();
    });
    $('.confirmfolder').on('click', createFolder);
    return $('.note .title').focus();
  });

}).call(this);
