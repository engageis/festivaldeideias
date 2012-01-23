App.Ideas.Show = App.BaseView.extend({

  initialize: function(){
    this.model = new App.Models.Idea
    _.bindAll(this)
    this.model.bind('save', this.model.save);
  },

  events: {
    'mousedown .editable' : 'editableClick'
  },

  editableClick: etch.editableInit
});
