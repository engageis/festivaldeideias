function Application(locale){
  
  this.locale = locale
  this.newIdeaView = new NewIdeaView()
  this.loginMenuView = new LoginMenuView()
  this.loginView = new LoginView()
  this.userMenuView = new UserMenuView()
  
}
