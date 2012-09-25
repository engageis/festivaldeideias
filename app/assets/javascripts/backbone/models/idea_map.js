App.Models.IdeaMap = Backbone.Model.extend({

  url: '/ideas.json',

  defaults: {
    title: "",
    headline: "",
  },

  initialize: function(){
    // this.url = $('.editable').attr('data-url');
  }
});
