function Application(locale, current_user) {
  
  this.locale = locale
  this.currentUser = current_user
  this.newIdeaView = new NewIdeaView
  this.loginView = new LoginView
  this.userMenuView = new UserMenuView
  this.flashView = new FlashView

  this.currentPath = function() {
    path = location.pathname + location.hash
    if(!/#/.test(path))
      path = path + "#"
    return path
  }
  this.history = [this.currentPath()]
  this.lastPath = function() {
    return this.history[this.history.length - 2]
  }
  this.hashChange = function() {
    this.history.push(this.currentPath())
  }
  this.back = function() {
    location.href = this.lastPath()
  }
  _.bindAll(this, "hashChange", "back")
  $(window).bind('hashchange', this.hashChange)

}
