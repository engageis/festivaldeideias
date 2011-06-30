var LoginView = Backbone.View.extend({

  el: $('#login'),

  events: {
    "click .provider": "submit",
    "click .close": "close"
  },

  initialize: function() {
    _.bindAll(this, "render")
  },

  render: function() {
    this.$('#return_to').val(location.href)
    this.el.fadeIn()
    return this
  },
  
  submit: function(event) {
    event.preventDefault()
    link = $(event.currentTarget)
    console.log(link)
    if(link.hasClass('disabled'))
      return
    this.$('a.provider').addClass('disabled')
    this.$('#provider').val(link.attr('href'))
    console.log(this.$('#provider').val())
    this.$('form').submit()
  },
  
  close: function() {
    this.$('#return_to').val(null)
    this.el.hide()
  }

})
