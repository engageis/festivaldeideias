var ShowUserView = Backbone.View.extend({

  el: $('#show_user'),
  
  events: {
    "click img.avatar, .upload": "openFileDialog",
    "change input[type=file]": "submit"
  },
  
  openFileDialog: function() {
    this.$('input[type=file]').click()
  },
  
  submit: function() {
    this.$('form').submit()
  },

  initialize: function() {
    this.$('.editable textarea').live('keydown', function() {
      if(!$(this).attr('data-prepared')) {
        $(this).attr('maxlength', $(this).parents('.editable').attr('data-maxlength'))
        $(this).maxlength()
        $(this).autoResize({extraSpace: 0})
        $(this).attr('data-prepared', true)
      }
    })
    this.$('.editable').each(function() {
      $(this).click(function(){
        $(this).addClass("editing")
      })
      $(this).editable("/" + app.locale + "/users/" + $(this).parents('#show_user').attr('data-id') + '.json', {
        data: function(){ return $(this).attr('data-raw') },
        type: ($(this).attr('data-type') || "textarea"),
        placeholder: ($(this).attr('data-placeholder') || $.fn.editable.defaults.placeholder),
        method: "PUT",
        name: 'user[' + $(this).attr('data-attribute') + ']',
        indicator : '<img src="/images/loading.gif">',
        onreset: function() {
          $(this).parent().removeClass("editing")
        },
        callback: function(value, settings) {
          idea = JSON.parse(value)
          $(this).attr('data-raw', idea[$(this).attr('data-attribute')])
          $(this).html(idea[($(this).attr('data-raw-attribute') || $(this).attr('data-attribute'))])
          $(this).removeClass("editing")
        }
      })
    })
    
  }
  
})
