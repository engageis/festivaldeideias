App.Users.Notifications = App.BaseView.extend({
  
  initialize: function(){
    _.bindAll(this);
    this.notification = new App.Common.Notifications({ el: this.$('#notifications')[0] });
  }

});
