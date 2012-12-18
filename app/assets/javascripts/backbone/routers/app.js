App.Router = Backbone.Router.extend({

  routes: {
    "continue_idea": "loadIdeaFromStore",
    "start" : "startNewIdea"
  },

  startNewIdea: function() {
    if (App.Common.isLoggedIn()) {
      App.Ideas.newIdea.openIdeaForm(); 
      location.hash = '';
    } else {
      location.href = '/sessions/new?redirect_url=' + location.href;
    }
  },

  loadIdeaFromStore: function () {
    App.Ideas.newIdea.openIdeaForm();
  }
});
