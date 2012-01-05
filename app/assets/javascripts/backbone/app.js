//= require_self
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views

var App = window.App = {
  Common: {
    init: function(){
      // Start JS router if it's not started yet
      if(!App.routes && _.isFunction(App.Router)){
        App.routes = new App.Router();
      }

      // Create existing flashes
      App.flashes = [];
      $('.flash').each(function(){
        App.flashes.push(new PLOTO.Flash({el: this}));
      });

      // Starting Facebox
      App.Common.startFacebox();
    },

    finish: function(){
      if(Backbone.history) {
        Backbone.history.start();
      }
    },

    startFacebox: function(){
      $('*[rel=facebox]').facebox();
    }
  }
};
