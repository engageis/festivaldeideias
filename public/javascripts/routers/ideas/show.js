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
    "confirm_fork": "confirmFork",
    "fork": "fork",
		"remove": "remove",
    "merge/:from_id": "merge"
  },
  
  closePopups: function() {
    this.closeLayoutPopups()
    app.confirmForkView.close()
    app.forkIdeaView.close()
    app.mergeIdeaView.close()
    app.removeIdeaView.close()
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
  
  confirmFork: function() {
    this.closePopups()
    app.confirmForkView.render()
  },

  fork: function() {
    this.closePopups()
    if(this.requireLogin())
      app.forkIdeaView.render()
  },

	remove: function () {
    this.closePopups()
		if(this.requireLogin())
			app.removeIdeaView.render()
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
