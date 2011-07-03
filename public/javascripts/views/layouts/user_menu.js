var UserMenuView = Backbone.View.extend({

  el: $('#user_menu'),

  events: {
    "click .user": "toggleMenu"
  },
  
  toggleMenu: function(event) {
    event.preventDefault()
    this.$(".menu").toggle()
  }

})
