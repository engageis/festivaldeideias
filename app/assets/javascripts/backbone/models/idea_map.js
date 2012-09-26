App.Models.IdeaMap = Backbone.Model.extend({
  defaults: {
    title: "",
    headline: "",
  }
});

App.Models.IdeasMap = Backbone.Collection.extend({
  model: App.Models.IdeaMap,
  url: '/ideias.json'
})