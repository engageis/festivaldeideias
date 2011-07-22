var ShowUserView = EditableView.extend({

  el: $('#show_user'),
  modelName: 'user',
  
  events: {
    "click img.avatar, .upload": "openFileDialog",
    "change input[type=file]": "submit"
  },
  
  openFileDialog: function() {
    this.$('input[type=file]').click()
  },
  
  submit: function() {
    this.$('form').submit()
  }
  
})
