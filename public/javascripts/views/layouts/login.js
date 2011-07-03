var LoginView = PopupView.extend({

  el: $('#login'),

  events: {
    "click .provider": "submit",
    "click .close": "close"
  },

  beforeRender: function() {
    this.$('#return_to').val(location.href)
  },
  
  beforeClose: function() {
    this.$('#return_to').val(null)
  },
  
  submit: function(event) {
    event.preventDefault()
    link = $(event.currentTarget)
    if(link.hasClass('disabled'))
      return
    this.$('a.provider').addClass('disabled')
    this.$('#provider').val(link.attr('href'))
    this.$('form').submit()
  }
  
})
