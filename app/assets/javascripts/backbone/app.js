//= require_self
//
//= require_tree ./views
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models

var App = window.App = {
  // Initializing the Object/Controller
  Ideas: {},

  Common: {
    init: function () {
      // Start JS router if it's not started yet
      if(!App.routes && _.isFunction(App.Router)){
        App.routes = new App.Router();
      }

      // Create existing flashes
      App.flashes = [];
      $('.flash').each(function () {
        App.flashes.push(new PLOTO.Flash({el: this}));
      });

      // Starting Facebox
      App.Common.startFacebox();
    },

    finish: function(){
      if (Backbone.history) {
        Backbone.history.start();
      }
    },

    startFacebox: function () {
      $('*[rel=facebox]').facebox();
    },

    initialize: function () {
        _.bindAll(
            this,
            "showDescription",
            "showRefinement",
            "showPublishing",
            "updateActiveLink"
        );
    },

    events: {
        "click a[href='#describe']": 'showDescription',
        "click a[href='#refine']": 'showRefinement',
        "click a[href='#publish']": 'showPublishing',
        "click .popup a": "updateActiveLink"
    },

    showDescription: function () {
        var box = $('.popup');
        box.find("#refine").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#describe").removeClass('hidden');
    },

    showRefinement: function () {
        var box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#refine").removeClass('hidden');
    },

    showPublishing: function () {
        var box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#refine").addClass('hidden');
        box.find("#publish").removeClass('hidden');
    },

    updateActiveLink: function (e) {
        var shorcuts, hash;
        shorcuts = $('.popup .shortcuts a');
        hash = e.target.hash;
        shortcuts.each(function () {
            alert(this.hash);
            if (this.hash === hash) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });
    }
  }
};
