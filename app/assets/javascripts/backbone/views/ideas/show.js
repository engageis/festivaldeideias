App.Ideas.Show = App.EditableView.extend({

  initialize: function(){
    _.bindAll(this);
    this.modelName = 'idea'
    this.prepareEditables();
  },


});
