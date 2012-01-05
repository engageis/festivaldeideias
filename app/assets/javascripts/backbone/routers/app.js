App.Router = Backbone.Router.extend({
  routes: {
    "example": "example"
  },
  /* You can let these functions empty
   * and bind the routes in the view.
   * Nevertheless you still need to define them.
   */
  example: function(){
    console.log('This is just an example');
  }
});
