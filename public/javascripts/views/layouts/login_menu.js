var LoginMenuView = Backbone.View.extend({

  el: $('#login_menu'),

  events: {
    "click .login": "showLogin"
  },
  
  showLogin: function(event) {
    event.preventDefault()
    app.loginView.render()
  }

})
