var ReviewConflictsRouter = ApplicationRouter.extend({

  routes: {
    "": "reviewConflicts",
    "login": "login",
    "sign_up": "signUp",
    "new_idea": "newIdea"
  },
  
  reviewConflicts: function() {
    app.reviewConflictsView.render()
  }

})
