var FlashView = Backbone.View.extend({

  el: $('#flash'),

  initialize: function() {
    _.bindAll(this, "render", "close")
    $(window).click(this.close)
    this.render()
  },

  render: function() {
    this.el.slideDown('slow')
    if(! this.$('a').length)
      setTimeout(this.close, 16000)
    return this
  },
  
  close: function() {
    this.el.slideUp('slow')
  }
  
})
