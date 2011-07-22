var ShowIdeaView = EditableView.extend({

  el: $('#show_idea'),
  modelName: 'idea',
  
  initialize: function() {
    _.bindAll(this, "selectItem")
    this.prepareEditables()
  },
  
  selectItem: function(name) {
    this.selectedItem = this.$('.menu a[href=#' + name + ']')
    this.$('.menu .selected').removeClass('selected')
    this.selectedItem.addClass('selected')
    this.$('.content > div').hide()
    this.$('.content .' + name).show()
  }
  
})
