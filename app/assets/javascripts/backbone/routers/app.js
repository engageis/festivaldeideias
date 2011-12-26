FDI.Router = Backbone.Router.extend({
  routes: {
    '/login' : 'loginAction'
  },
  loginAction: function(){
    jQuery.facebox( { div: "#login" } )
  }
});
