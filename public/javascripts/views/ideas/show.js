var ShowIdeaView = Backbone.View.extend({

  el: $('#idea'),
  
  events: {
    "click .fork_idea": "showForkIdea"
  },
  
  initialize: function() {
    _.bindAll(this, "selectItem")
    this.$('.editable').each(function() {
      $(this).click(function(){
        $(this).addClass("editing")
      })
      $(this).editable("/" + app.locale + "/ideas/" + $(this).parents('#idea').attr('data-id'), {
        data: function(){ return $(this).attr('data-raw') },
        type: ($(this).attr('data-type') || "textarea"),
        method: "PUT",
        name: 'idea[' + $(this).attr('data-attribute') + ']',
        onreset: function() {
          $(this).parent().removeClass("editing")
        },
        callback: function(value, settings) {
          idea = JSON.parse(value)
          $(this).attr('data-raw', idea[$(this).attr('data-attribute')])
          $(this).html(idea[($(this).attr('data-raw-attribute') || $(this).attr('data-attribute'))])
          $(this).removeClass("editing")
        }
      })
    })
    
  },
  
  selectItem: function(name) {
    this.selectedItem = this.$('.menu a[href=#' + name + ']')
    this.$('.menu .selected').removeClass('selected')
    this.selectedItem.parent().addClass('selected')
    this.$('.content > div').hide()
    this.$('.content .' + name).show()
  },
  
  showForkIdea: function(event) {
    event.preventDefault()
    if($('#user_menu').length > 0) {
      app.forkIdeaView.render()
    } else {
      app.loginView.render()
    }
  }

})
