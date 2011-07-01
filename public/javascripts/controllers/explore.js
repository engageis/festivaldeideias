var ExploreController = Backbone.Controller.extend({

  routes: {
    "": "recommended",
    "recommended": "recommended",
    "popular": "popular",
    "recent": "recent",
    ":name": "category"
  },

  recommended: function() {
    this.view = new ExploreView({
      collection: new Ideas({
        search: {recommended_equals: true}
      })
    })
  },
  
  popular: function() {
    this.view = new ExploreView({
      collection: new Ideas({
        search: {meta_sort: "likes.desc"}
      })
    })
  },
  
  recent: function() {
    this.view = new ExploreView({
      collection: new Ideas({
        search: {meta_sort: "created_at.desc"}
      })
    })
  },
  
  quick: function(type) {
    this.view = new ExploreView({
      collection: new Ideas({
        search: {category_id_equals: 1}
      })
    })
  },

  category: function(name) {
    var id = $('#explore a[href=#' + name + ']').attr('data-id')
    this.view = new ExploreView({
      collection: new Ideas({
        search: {category_id_equals: id}
      })
    })
  }

})
