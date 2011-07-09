var LoginView = PopupView.extend({

  el: $('#login'),

  events: {
    "click .provider": "submit"
  },

  initialize: function() {
    _.bindAll(this, "render", "returnTo")
  },
  
  returnTo: function(url) {
    if(typeof(url) != 'undefined') {
      this.$('#return_to').val(url)
    } else {
      return this.$('#return_to').val()
    }
  },
  
  beforeRender: function() {
    if(!this.returnTo()) {
      this.returnTo(app.lastPath())
    }
  },
  
  beforeClose: function() {
    this.returnTo(null)
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
