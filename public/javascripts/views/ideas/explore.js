var ExploreView = PaginatedView.extend({
  el: $('#explore'),
  collection: new Ideas(),
  modelView: IdeaView
})
