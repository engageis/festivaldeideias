FDI.login = Backbone.View.extend({

  initialize: function(){
    _.bindAll(this, 'render', 'loginAction');
    this.bindRoutes();
    this.loadLastFragment();
  },

  loginAction: function(){
    jQuery.facebox({ div : "#login" })
  }
});
