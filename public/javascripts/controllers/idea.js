var IdeaController = Backbone.Controller.extend({

  routes: {
    "": "description",
    "description": "description",
    "have": "have",
    "need": "need"
  },
  
  description: function() {
    this.selectItem("description")
    this.view = new ShowIdeaView({
      el: $('#idea .content .description')
    })
  },

  have: function() {
    this.selectItem("have")
    this.view = new ShowIdeaView({
      el: $('#idea .content .have')
    })
  },
  
  need: function() {
    this.selectItem("need")
    this.view = new ShowIdeaView({
      el: $('#idea .content .need')
    })
  },
  
  selectItem: function(name) {
    this.selectedItem = $('#idea .menu a[href=#' + name + ']')
    $('#idea .menu .selected').removeClass('selected')
    this.selectedItem.parent().addClass('selected')
  }

})
