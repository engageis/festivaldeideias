var ReviewConflictsView = Backbone.View.extend({

  el: $('#review_conflicts'),

  events: {
    "click .section.theirs, .section.ours": "toggleSection"
  },
  
  initialize: function(options) {
    this.selectText = options.selectText
    this.deselectText = options.deselectText
  },
  
  toggleSection: function(event) {
    event.preventDefault()
    var section
    if($(event.target).hasClass('section'))
      section = $(event.target)
    else
      section = $(event.target).parents('.section')
    if(section.hasClass('selected')) {
      section.removeClass('selected')
      section.find('.click').html(this.selectText)
    } else {
      section.addClass('selected')
      section.find('.click').html(this.deselectText)
    }
  }
  
})
