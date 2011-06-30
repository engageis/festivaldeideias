var MenuView = Backbone.View.extend({

  el: $('#menu'),

  events: {
    "click .login": "showLogin"
  },
  
  showLogin: function(event) {
    event.preventDefault()
    app.loginView.render()
  }

})
