var ShowIdeaRouter = ApplicationRouter.extend({

  routes: {
    "": "description",
    "login": "login",
    "sign_up": "signUp",
    "new_idea": "newIdea",
    "description": "description",
    "have": "have",
    "need": "need",
    "versions": "versions",
    "fork": "fork",
    "merge/:from_id": "merge"
  },
  
  closePopups: function() {
    this.closeLayoutPopups()
    app.forkIdeaView.close()
    app.mergeIdeaView.close()
  },
  
  description: function() {
    this.selectItem("description")
  },

  have: function() {
    this.selectItem("have")
  },
  
  need: function() {
    this.selectItem("need")
  },
  
  versions: function() {
    this.selectItem("versions")
  },
  
  fork: function() {
    if(this.requireLogin())
      app.forkIdeaView.render()
  },
  
  merge: function(fromId) {
    if(this.requireLogin()) {
      app.mergeIdeaView.fromId = fromId
      app.mergeIdeaView.render()
    }
  },
  
  selectItem: function(name) {
    this.closePopups()
    app.showIdeaView.selectItem(name)
  }
  
})
