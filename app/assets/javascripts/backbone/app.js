//= require_self
//
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views

var App = window.App = {
    // Initializing the Object/Controller
    Ideas: {},
    Users: {},
    Pages: {},
    Models: {
        Idea: {}
    },

    Common: {
        init: function () {
            var notification;

            // Start JS router if it's not started yet
            if(!App.routes && _.isFunction(App.Router)){
                App.routes = new App.Router();
            }

            // Create existing flashes
            App.flashes = [];
            $('.flash').each(function () {
                App.flashes.push(new App.Flash({el: this, timeout: 5000}));
            });
            // Starting Facebox and modal alerts
            App.Common.startFacebox();
            App.applyMaskMoney();
            App.loadMaskOnFaceboxReveal();
            // Sempre executar
            App.Ideas.newIdea = new App.Ideas.NewIdea();
            App.fbEvents = new App.FbEvents();
            // Carrega os eventos do facebook e apende na barra lateral
            App.Common.startPjaxLinks();

            if (App.Common.isLoggedIn()) {
                notification = new App.Common.Notifications({ el: $('.user_actions')[0] });
            }


        },

        finish: function(){
            if (Backbone.history) {
                Backbone.history.start();
            }
        },

        startFacebox: function () {
            $('*[rel=facebox]').click(function () {
                var href = this.href;
                $.facebox({ div: href });
            });

            // Modal Alert
            if ($('#modal_alert').length) {
                jQuery.facebox({ div: '#modal_alert' }, 'modal_alert');
            }
        },

        startPjaxLinks: function () {
            var lis, pjaxLinks, container, ideasTitle, ideasAbout;
            // Não executar no home.
            if (window.location.pathname === '/') { return; }
            // Área que será substituída, primeiro por uma imagem.
            container = $('[data-pjax-container]');
            lis = $('.navigation.filter li');
            pjaxLinks = $('a', lis);
            ideasTitle = $('h1.title');
            ideasAbout = $('h2.info');
            // Não dá para usar o container como parâmetro, porque
            // a função abaixo espera por uma String.
            pjaxLinks.pjax('[data-pjax-container]').click(function () {
                var link = $(this);
                // A imagem de "carregando"
                container.html("<img class='loading-image' src='/loading.gif' />");
                // Remove a seleção dos outros links
                lis.removeClass('selected');
                // Deixa o link atual selecionado
                link.parents('li').addClass('selected');
                ideasTitle.html(link.data('title'));
                ideasAbout.html(link.data('about'));
            });
        },

        isLoggedIn: function(){
            return Boolean($('.user_actions .logged_in').length);
        },

        Notifications: Backbone.View.extend({

            events: {
                'click li.notifications a.globe' : 'showNotes',
                'click a.collab-ramify' : 'confirmRamify'
            },

            initialize: function(){
              var self = this;
                this.url = $(this.el).data('url');
                this.notes = this.$('.notes');
                this.counter = this.$('.count');
                $(document).click(function(e){
                    if(!$.contains($('ul.user_actions')[0], e.target)){
                        self.notes.fadeOut(200);
                    }
                });
            },

            confirmRamify: function(event){
                event.preventDefault();
                var self = $(event.currentTarget);
                var url = self.attr('data-href');
                $('a#ramify_confirm').attr('href', url); 
                $.facebox({ div: "#new_ramify" });
            },
            
            showNotes: function(event){
                event.preventDefault();
                var self = this;
                self.notes.fadeToggle(200);
                if (this.counter) {
                    $.ajax({
                        url: self.url,
                        type: "PUT",
                        data: "notifications_read_at",
                        success: function(data) { self.counter.remove(); }
                    });
                }
            }

        }),
    },

    applyMaskMoney: function(){
      $('.currency').maskMoney({
        showSymbol: true,
        symbol:"R$",
        decimal:".", 
        thousands:"", 
        precision: 2
      }); 
    },

    loadMaskOnFaceboxReveal: function(){
      $(document).bind('afterReveal.facebox', function(){
        App.applyMaskMoney();
      });
    }
};

