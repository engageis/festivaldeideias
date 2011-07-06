var ExploreController = Backbone.Controller.extend({

  routes: {
    "": "recommended",
    "recommended": "recommended",
    "popular": "popular",
    "recent": "recent",
    ":name": "category"
  },

  recommended: function() {
    this.selectItem("recommended")
    this.view = new ExploreView({
      collection: new Ideas({
        search: {
          recommended_equals: true,
          meta_sort: "created_at.desc"
        }
      })
    })
  },
  
  popular: function() {
    this.selectItem("popular")
    this.view = new ExploreView({
      collection: new Ideas({
        search: {
          meta_sort: "likes.desc"
        }
      })
    })
  },
  
  recent: function() {
    this.selectItem("recent")
    this.view = new ExploreView({
      collection: new Ideas({
        search: {
          meta_sort: "created_at.desc"
        }
      })
    })
  },
  
  category: function(name) {
    this.selectItem(name)
    var id = this.selectedItem.attr('data-id')
    this.view = new ExploreView({
      collection: new Ideas({
        search: {
          category_id_equals: id,
          meta_sort: "created_at.desc"
        }
      })
    })
  },
  
  selectItem: function(name) {
    this.selectedItem = $('#explore .menu a[href=#' + name + ']')
    $('#explore .menu .selected').removeClass('selected')
    this.selectedItem.parent().addClass('selected')
  }

})
