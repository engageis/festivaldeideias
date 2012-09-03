App.Users.Show = App.BaseView.extend({

  initialize: function(){
    this.user = new App.Models.User(this.$("#email_notifications").data("json"))
  },
  
  events: {
    "change #email_notifications": "updateEmailNotifications"
  },

  updateEmailNotifications: function(event) {
    this.user.save({email_notifications: $(event.target).is(":checked")})
  }

});
