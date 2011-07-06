var IdeaController = Backbone.Controller.extend({

  routes: {
    "": "description",
    "description": "description",
    "have": "have",
    "need": "need"
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
  
  selectItem: function(name) {
    $('#idea .content > div').hide()
    $('#idea .content .' + name).show()
    this.selectedItem = $('#idea .menu a[href=#' + name + ']')
    $('#idea .menu .selected').removeClass('selected')
    this.selectedItem.parent().addClass('selected')
  }

})
