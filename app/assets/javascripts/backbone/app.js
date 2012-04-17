//= require_self
//
//= require_tree ./routers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views

var App = window.App = {
  // Initializing the Object/Controller
  Ideas: {},
  Pages: {},
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
        App.flashes.push(new App.Flash({el: this, timeout: 5000}));
      });

      // Starting Facebox
      App.Common.startFacebox();

      // Sempre executar
      App.Ideas.newIdea = new App.Ideas.NewIdea();
      App.fbEvents = new App.FbEvents();
      // Carrega os eventos do facebook e apende na barra lateral
      App.Common.startPjaxLinks();

      if (App.Common.isLoggedIn())
        var notification = new App.Common.Notifications({ el: $('.user_actions')[0] });
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
      if (!$('.user_actions .logged_in').length) {
          return false;
      }
      return true;
    },

    Notifications: Backbone.View.extend({

      events: {
        'click li.notifications' : 'showNotes'
      },

      initialize: function(){
        this.url = $(this.el).data('url');
        this.notes = this.$('.notes');
        this.counter = this.$('.count');
      },

      showNotes: function(){
        var self = this;
        self.notes.fadeToggle(200);
        if (this.counter){
          $.ajax({
            url: self.url,
            type: "PUT",
            data: "notifications_read_at",
            success: function(data){
              self.counter.remove();
            }
          });
        }
      }
    }),
  }
};
