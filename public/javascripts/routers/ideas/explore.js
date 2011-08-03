var ExploreRouter = ApplicationRouter.extend({

  routes: {
    "": "featured",
    "login": "login",
    "sign_up": "signUp",
    "new_idea": "newIdea",
    "featured": "featured",
    "popular": "popular",
    "recent": "recent",
    ":name": "category"
  },

  featured: function() {
    this.selectItem("featured")
    this.view = new ExploreView({
      collection: new Ideas({
        search: {
          featured_equals: true,
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
    this.closePopups()
    this.selectedItem = $('#explore .menu a[href=#' + name + ']')
    $('#explore .menu .selected').removeClass('selected')
    this.selectedItem.addClass('selected')
  }

})
