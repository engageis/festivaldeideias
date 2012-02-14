App.BaseView = Backbone.View.extend({

  //el: $('body')
  el: 'body',

  requireLogin: function(){
    if (!$('.user_actions .logged_in').length) {
      // Gotta use name because the STUPID facebox duplicates all elements
      // so IDs cannot be used. Please, do not use facebox.
      $('input[name=redirect_url]').val(location.href)
      $.facebox({ div : "#login" })
      return false;
    }
    return true;
  }
});
