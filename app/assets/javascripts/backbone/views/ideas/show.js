App.Ideas.Show = App.EditableView.extend({

  initialize: function () {
    _.bindAll(this, 'colaborate');
    this.modelName = 'idea';
    this.bindRoutes();
    this.prepareEditables();
    $(document).bind('afterClose.facebox', function () {
      Backbone.history.navigate('');
    });

    $(document).bind("afterReveal.facebox", function () {
      App.applyMoneyMask($('input.currency'));
    });

    //$(".currency textarea").live("focus", function () {
      //App.applyMoneyMask($(this));
    //});
  },

  bindRoutes: function () {
    App.routes.bind('route:colaborate', this.colaborate);
  },

  colaborate: function(){
    if (this.requireLogin()) {
      $.facebox({div : "#colaborate"});
    }
  }


});
