App.Models.IdeaPin = Backbone.Model.extend({
  defaults: {
    title: "",
    headline: "",
  }
});

App.Models.IdeasMap = Backbone.Collection.extend({
  model: App.Models.IdeaPin,
  url: '/ideias.json'
})