var PopupView = Backbone.View.extend({

  el: $('#new_idea'),

  events: {
    "click .close": "close"
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
  
  close: function(event) {
    event.preventDefault()
    this.beforeClose(event)
    this.$('.overlay').hide()
    this.$('.popup').hide()
  }

})
