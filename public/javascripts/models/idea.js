var Idea = Backbone.Model.extend({
})
var Ideas = PaginatedCollection.extend({
  model: Idea,
  baseUrl: "ideas"
})
