var ReviewConflictsView = Backbone.View.extend({

  el: $('#review_conflicts'),

  events: {
    "click .section.theirs, .section.ours": "toggleSection",
    "submit form": "setConflictAttributes"
  },
  
  initialize: function(options) {
    this.selectText = options.selectText
    this.deselectText = options.deselectText
    _.bindAll(this, "loopAttributes", "loopSections", "loopLines", "validateAttribute")
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
  },
  
  setConflictAttributes: function(event) {
    this.conflictAttributes = {}
    this.$('.attribute').each(this.loopAttributes)
    this.$('#conflict_attributes').val(JSON.stringify(this.conflictAttributes))
    this.scrollTo = null
    this.$('.attribute .error').hide()
    $.each(this.conflictAttributes, this.validateAttribute)
    if(this.scrollTo != null) {
      event.preventDefault()
      $(window).scrollTo(this.scrollTo)
    }
  },
  
  validateAttribute: function(attribute, value) {
    if(value == null){
      this.$('.attribute[data-attribute=' + attribute + '] .error').show()
      if(this.scrollTo == null)
        this.scrollTo = this.$('.attribute[data-attribute=' + attribute + ']')
    }
  },
  
  loopAttributes: function(index, element) {
    var attribute = $(element).attr('data-attribute')
    this.conflictAttributes[attribute] = null
    $(element).find('.section.selected').each(this.loopSections)
  },
  
  loopSections: function(index, element) {
    $(element).find('.lines p').each(this.loopLines)
  },
  
  loopLines: function(index, element) {
    var attribute = $(element).parents('.attribute').attr('data-attribute')
    if(this.conflictAttributes[attribute] == null)
      this.conflictAttributes[attribute] = ""
    else
      this.conflictAttributes[attribute] = this.conflictAttributes[attribute] + "\n"
    this.conflictAttributes[attribute] = this.conflictAttributes[attribute] + $(element).html()
  }
  
})
