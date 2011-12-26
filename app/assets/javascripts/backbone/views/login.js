FDI.login = Backbone.View.extend({

  initialize: function(){
    _.bindAll(this, 'render');
    this.bindRoutes();
    this.loadLastFragment();
  },
});
