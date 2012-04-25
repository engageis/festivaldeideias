App.Ideas.Show = App.EditableView.extend({

  initialize: function () {
    _.bindAll(this, 'colaborate');
    this.modelName = 'idea';
    this.bindRoutes();
    this.prepareEditables();
    $(document).bind('afterClose.facebox', function () {
      Backbone.history.navigate('');
    });

    $(".currency textarea").live("focus", function () {
      $(this).maskMoney({ symbol: 'R$ ', showSymbol: true, thousands: '.', decimal: ',', symbolStay: true, allowNegative: false }).applyMask();
    });

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
