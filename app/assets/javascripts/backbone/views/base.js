FDI.baseView = Backbone.View.extend({

  el: $('body'),

  isLoggedIn: function(){
    return this.$('#user_panel .data').length > 0;
  },

  getStore: function(){
    if(!this.store){
      this.store = new Store('view');
    }
    return this.store;
  },

  loadLastFragment: function(){
    var fragment = this.getStore().get('lastFragment');
    if(fragment){
      this.store.remove('lastFragment');
      Backbone.history.navigate(fragment, true);
    }
  },

  requireLogin: function(){
    if(this.isLoggedIn()){
      return true;
    }
    else{
      this.getStore().set('lastFragment', Backbone.history.getFragment());
      this.loginDialog();
      return false;
    }
  },

  loginDialog: function(){
    $.facebox({ div: '#login' });
  }
})
