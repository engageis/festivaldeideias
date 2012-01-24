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
            App.Common.startPjaxLinks();
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

        startPjaxLinks: function () {
            var lis, pjaxLinks, container;
            // Não executar no home.
            if (window.location.pathname === '/') { return; }
            // Área que será substituída, primeiro por uma imagem.
            container = $('[data-pjax-container]');
            lis = $('.navigation.filter li');
            pjaxLinks = $('a', lis);
            // Não dá para usar o container como parâmetro, porque
            // a função abaixo espera por uma String.
            pjaxLinks.pjax('[data-pjax-container]').click(function () {
                // A imagem de "carregando"
                container.html("<img class='loading-image' src='/loading.gif' />");
                // Remove a seleção dos outros links
                lis.removeClass('selected');
                // Deixa o link atual selecionado
                $(this).parents('li').addClass('selected');
            });
        }
    }
};
