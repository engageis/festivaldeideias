//= require_self
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views

window.FDI = {
  // Ideas Controller/View
  ideas: {
    index:  function(){ FDI.View = new FDI.IdeaIndexView() },
    show:   function(){ FDI.View = new FDI.IdeaShowView()  }
  },

  users: {
    edit: function(){}
  },

  common: {
    finish: function(){
      Backbone.history.start();
    },

    init: function(){
      if ( !window.store ) {
        window.store = new Store('global');
      }
      if ( !FDI.router ) {
        FDI.router = new FDI.Router();
      }
    },

    handleFragmentEvent: function(){
      if(store.get('lastFragment')){
        window.location.href = window.location.href + '#' + store.get('lastFragment');
        store.remove('lastFragment');
      }
    },

  }
}
