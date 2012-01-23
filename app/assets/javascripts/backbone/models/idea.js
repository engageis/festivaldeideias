App.Models.Idea = Backbone.Model.extend({

  url: '',

  defaults: {
    title: "",
    headline: "",
  },

  initialize: function(){
    this.url = $('.editable').attr('data-url');
  },

  save: function(){
    console.log('Cool');
  }
});
