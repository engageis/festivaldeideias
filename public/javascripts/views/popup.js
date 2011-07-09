var PopupView = Backbone.View.extend({

  events: {
    "submit form": "disableSubmit"
  },
  
  initialize: function() {
    _.bindAll(this, "render")
  },
  
  beforeRender: function() {
  },

  render: function() {
    this.beforeRender()
    this.$('.overlay').show()
    this.$('.popup').fadeIn()
    return this
  },
  
  beforeClose: function(event) {
  },
  
  close: function() {
    this.beforeClose()
    this.$('.overlay').hide()
    this.$('.popup').hide()
  },

  disableSubmit: function() {
    this.$("[type=submit]").attr('disabled', true)
  }

})
