(function() {
  $(function() {
    var addFolderToList, addNoteToList, bindList, checkListItem, clearInputs, createFolder, createNote, deleteListItem, deleteNote, editAmount, editFolder, editListItem, editNoteField, editTimer, folders, insertItemAfter, moveListItem, notes, removeNoteFromList, renderList, resetListIndex, saveFolder, saveNote, selectFolder, selectNote, setSaveTimer, setValue, startList, toggleFolderList;
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
      $('.list').empty();
      if ((_ref = note.list) != null ? _ref.length : void 0) {
        return renderList($('.list'), note.list);
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
      var element;
      element = $("<div data-id='" + note._id + "' data-field='title'>" + note.title + "</div>");
      $('.notelist').append(element);
      element.click(function() {
        return selectNote($(this));
      });
      return element;
    };
    removeNoteFromList = function(noteId) {
      $(".notelist [data-id='" + noteId + "'").remove();
      $('.note .title').val('').attr('data-id', '');
      $('.note .text').val('').attr('data-id', '');
      return $('.note .list').empty();
    };
    createNote = function() {
      var id, noteListElement;
      $('.list').empty();
      clearInputs();
      id = uuid.v4();
      notes[id] = {
        _id: id,
        title: '',
        path: $('.currentfolder').attr('data-current-path'),
        deleted: false
      };
      $('.note .title').attr('data-id', id);
      $('.note .text').attr('data-id', id);
      noteListElement = addNoteToList(notes[id]);
      $('.notelist .selected').removeClass('selected');
      noteListElement.addClass('selected');
      $('.note .title').focus();
      return id;
    };
    deleteNote = function() {
      var id;
      id = $('.note .title').attr('data-id');
      if (id) {
        $.ajax({
          type: 'POST',
          url: '/deletenote',
          data: {
            _id: id
          }
        });
      }
      return removeNoteFromList(id);
    };
    addFolderToList = function(folder) {
      var node;
      node = $("<div data-id='" + folder._id + "' data-path='" + folder.path + "' class='folder' data-type='folder' data-field='name'><i class='icon ion-ios7-bookmarks-outline'></i><div data-id='" + folder._id + "'>" + (folder.name != null ? folder.name : void 0) + "</div></div>");
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
      $('.list').empty();
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
      $('.note .text').val('');
      $('.note .title').attr('data-id', '');
      return $('.note .text').attr('data-id', '');
    };
    startList = function(button) {
      var list;
      list = button.siblings('.list');
      renderList(list);
      return list.find('.listtext').focus();
    };
    renderList = function(container, list) {
      var listTemplate;
      listTemplate = nunjucks.render('listitem.html', {
        list: list
      });
      container.append(listTemplate);
      bindList(container);
      if (list) {
        return $('.note .text').attr('tabindex', list.length);
      }
    };
    bindList = function(container) {
      container.find('.listtext').off().on('keypress', function(e) {
        return insertItemAfter($(this), e);
      }).on('input', function() {
        return editListItem($(this));
      });
      container.find('.listcheckbox').off().on('click', function() {
        return checkListItem($(this).parent());
      });
      container.find('.listclose').off().on('click', function() {
        return deleteListItem($(this).parent());
      });
      container.find('.listmoveup').off().on('click', function() {
        return moveListItem($(this).parent(), -1);
      });
      return container.find('.listmovedown').off().on('click', function() {
        return moveListItem($(this).parent(), 1);
      });
    };
    insertItemAfter = function(inputControl, e) {
      var item, itemIndex, newItem, noteId;
      if (e.which === 13) {
        e.preventDefault();
        noteId = $('.note .title').attr('data-id');
        item = inputControl.parent();
        itemIndex = parseInt(item.attr('data-index'));
        notes[noteId].list.splice(itemIndex + 1, 0, {
          text: '',
          checked: false
        });
        newItem = item.clone();
        item.after(newItem);
        newItem.find('.listtext').text('').focus();
        newItem.removeClass('checked');
        newItem.find('.listcheckbox').removeClass('ion-ios7-checkmark-outline').addClass('ion-ios7-circle-outline');
        resetListIndex(newItem.parent());
        return bindList(newItem.parent());
      }
    };
    editListItem = function(input) {
      var list, listIndex, listItem, noteId;
      noteId = $('.note .title').attr('data-id');
      if (!noteId) {
        noteId = createNote();
      }
      if (!notes[noteId].list) {
        notes[noteId].list = [];
      }
      list = notes[noteId].list;
      listItem = input.parent();
      if (listItem.attr('data-index')) {
        listIndex = parseInt(listItem.attr('data-index'));
      } else {
        listIndex = list.length;
        listItem.attr('data-index', listIndex);
      }
      console.log(listIndex, list);
      if (list.length < (listIndex + 1)) {
        list.push({
          text: input.text(),
          checked: false
        });
        renderList(listItem.parent());
      } else {
        list[listIndex].text = input.text();
      }
      return setSaveTimer(noteId);
    };
    checkListItem = function(control) {
      var listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      listIndex = control.attr('data-index');
      if (!noteId || !notes[noteId].list || !notes[noteId].list[listIndex]) {
        return;
      }
      notes[noteId].list[listIndex].checked = !notes[noteId].list[listIndex].checked;
      control.toggleClass('checked');
      control.find('.listcheckbox').toggleClass('ion-ios7-checkmark-outline').toggleClass('ion-ios7-circle-outline');
      return setSaveTimer(noteId);
    };
    deleteListItem = function(control) {
      var listContainer, listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      listIndex = control.attr('data-index');
      if (!noteId || !notes[noteId].list || !notes[noteId].list[listIndex]) {
        return;
      }
      notes[noteId].list.splice(listIndex, 1);
      control.remove();
      listContainer = control.closest('.list');
      resetListIndex(listContainer);
      return setSaveTimer(noteId);
    };
    moveListItem = function(control, relativePosition) {
      var item, list, listContainer, listIndex, noteId;
      noteId = $('.note .title').attr('data-id');
      if (!noteId || !notes[noteId].list) {
        return;
      }
      listIndex = parseInt(control.attr('data-index'));
      list = notes[noteId].list;
      console.log(list);
      item = list.splice(listIndex, 1);
      list.splice(listIndex + relativePosition, 0, item[0]);
      if (relativePosition > 0) {
        control.insertAfter(control.next());
      } else {
        control.insertBefore(control.prev());
      }
      listContainer = control.closest('.list');
      resetListIndex(listContainer);
      return setSaveTimer(noteId);
    };
    resetListIndex = function(container) {
      var index;
      index = 0;
      container.find('.listitem').each(function() {
        $(this).attr('data-index', index++);
        return $(this).find('.listtext').attr('tabindex', index + 2);
      });
      return $('.note .text').attr('tabindex', index + 2);
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
    $('.startlist').on('click', function() {
      return startList($(this));
    });
    $('.folders').on('click', toggleFolderList);
    $('.newfolder').on('click', function() {
      return $(this).siblings('*').show();
    });
    $('.confirmfolder').on('click', createFolder);
    return $('.note .title').focus();
  });

}).call(this);
