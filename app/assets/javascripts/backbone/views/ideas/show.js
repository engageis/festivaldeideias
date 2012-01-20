App.Ideas.Show = App.BaseView.extend({

  initialize: function(){
    this.model = new App.Models.Idea
    _.bindAll(this)
    this.model.bind('save', this.model.save);
  },

  events: {
    'click a[href="#edit"]' : 'highlightEditable',
    'mousedown .editable' : 'editableClick'
  },

  editableClick: etch.editableInit,

  highlightEditable: function(){

    var editable = $('.editable');
    var helper = $('.idea_edit_helper')
    editable.addClass('highlighted');
    helper.fadeIn('slow', function(){
      setTimeout(1000, function(){ helper.fadeOut(); })
    })

  }

});
