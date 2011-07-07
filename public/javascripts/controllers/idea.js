var IdeaController = Backbone.Controller.extend({

  routes: {
    "": "description",
    "description": "description",
    "have": "have",
    "need": "need"
  },
  
  description: function() {
    app.showIdeaView.selectItem("description")
  },

  have: function() {
    app.showIdeaView.selectItem("have")
  },
  
  need: function() {
    app.showIdeaView.selectItem("need")
  }
  
})
