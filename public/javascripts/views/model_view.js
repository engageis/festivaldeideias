var ModelView = Backbone.View.extend({
  initialize: function(){
    this.render()
  },
  render: function() {
    this.el.html(Mustache.to_html(this.template.html(), this.model))
    return this
  }
})
