var ShowIdeaView = Backbone.View.extend({

  initialize: function() {
    this.render()
  },
  
  render: function() {
    this.$('.text').editable("/" + app.locale + "/ideas/" + this.el.parent().attr('data-id'), {
      data: this.$('.text').attr('data-raw'),
      type: "textarea",
      method: "PUT",
      name: 'idea[' + this.el.attr('class') + ']',
      callback : function(value, settings) {
        idea = JSON.parse(value)
        $(this).html(idea[$(this).parent().attr('class') + '_html'])
      }
    })
    $('#idea .content > div').hide()
    this.el.show()
    return this
  }
  
})
