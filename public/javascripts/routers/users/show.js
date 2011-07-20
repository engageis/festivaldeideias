var ShowUserRouter = ApplicationRouter.extend({

  routes: {
    "": "show",
    "login": "login",
    "sign_up": "signUp",
    "new_idea": "newIdea"
  },
  
  show: function() {
    app.showUserView.render()
  }

})
