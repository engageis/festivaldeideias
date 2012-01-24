App.BaseView = Backbone.View.extend({

  //el: $('body')
  el: 'body',

  requireLogin: function(){
    if (!$('.user_actions .logged_in').length) {
      $.facebox({ div : "#login" })
      return false;
    }
    return true;
  }
});
