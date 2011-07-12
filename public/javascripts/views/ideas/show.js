var ShowIdeaView = Backbone.View.extend({

  el: $('#show_idea'),
  
  initialize: function() {
    _.bindAll(this, "selectItem")
    this.$('.editable textarea').live('keydown', function() {
      if(!$(this).attr('data-prepared')) {
        $(this).attr('maxlength', $(this).parents('.editable').attr('data-maxlength'))
        $(this).maxlength()
        $(this).autoResize({extraSpace: 0})
        $(this).attr('data-prepared', true)
      }
    })
    this.$('.editable').each(function() {
      $(this).click(function(){
        $(this).addClass("editing")
      })
      $(this).editable("/" + app.locale + "/ideas/" + $(this).parents('#show_idea').attr('data-id'), {
        data: function(){ return $(this).attr('data-raw') },
        type: ($(this).attr('data-type') || "textarea"),
        method: "PUT",
        name: 'idea[' + $(this).attr('data-attribute') + ']',
        indicator : '<img src="/images/loading.gif">',
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
    this.selectedItem.addClass('selected')
    this.$('.content > div').hide()
    this.$('.content .' + name).show()
  }
  
})
