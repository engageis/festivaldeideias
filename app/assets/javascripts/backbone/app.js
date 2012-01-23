//= require_self
//
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views

var App = window.App = {
    // Initializing the Object/Controller
    Ideas: {},
    Models: {
      Idea: {}
    },

    Common: {
        init: function () {
            // Start JS router if it's not started yet
            if(!App.routes && _.isFunction(App.Router)){
                App.routes = new App.Router();
            }

            // Create existing flashes
            App.flashes = [];
            $('.flash').each(function () {
                App.flashes.push(new App.Flash({el: this}));
            });

            // Starting Facebox
            App.Common.startFacebox();

            // Sempre executar
            App.Ideas.newIdea = new App.Ideas.NewIdea();
        },

        finish: function(){
            if (Backbone.history) {
                Backbone.history.start();
            }
        },

        startFacebox: function () {
            // NOTE: Tive que modificar isto.
            // É pra funcionar igual (só que melhor).
            // Qualquer dúvida, me pergunte (Chico) por quê?
            $('*[rel=facebox]').click(function () {
                var href = this.href;
                $.facebox({ div: href });
            });
        },
    }
};
