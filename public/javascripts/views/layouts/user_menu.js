var UserMenuView = Backbone.View.extend({

  el: $('#user_menu'),
  
  events: {
    "click .user": "toggleMenu"
  },

  render: function() {
    this.$(".menu").show()
    return this
  },

  close: function() {
    this.$(".menu").hide()
  },

  toggleMenu: function(event) {
    event.preventDefault()
    this.$(".menu").toggle()
  }

})
