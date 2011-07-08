var IndexView = Backbone.View.extend({

  el: $('#content'),

  events: {
    "click .new_idea a": "showNewIdea"
  },
  
  showNewIdea: function(event) {
    event.preventDefault()
    if($('#user_menu').length > 0) {
      app.newIdeaView.render()
    } else {
      app.loginView.render()
    }
  }

})
