var EditableView = Backbone.View.extend({

  initialize: function() {
    this.prepareEditables()
  },
  
  prepareEditables: function() {
    _.bindAll(this, "prepareEditable", "updateUrl")
    this.$('.editable textarea').live('keydown', function() {
      if(!$(this).attr('data-prepared')) {
        $(this).attr('maxlength', $(this).parents('.editable').attr('data-maxlength'))
        $(this).maxlength()
        $(this).autoResize({extraSpace: 0})
        $(this).attr('data-prepared', true)
      }
    })
    this.$('.editable textarea').live('focus', this.positionButtons)
    this.$('.editable textarea').live('keyup', this.positionButtons)
    this.$('.editable textarea').live('keydown', this.keydown)
    this.$('.editable').each(this.prepareEditable)
  },
  
  prepareEditable: function(index, element) {
    element = $(element)
    element.click(function(){
      $(this).addClass("editing")
    })
    _.bind(this.dataRaw, element)
    element.editable(this.updateUrl(), {
      data: this.dataRaw,
      type: (element.attr('data-type') || "textarea"),
      placeholder: (element.attr('data-placeholder') || $.fn.editable.defaults.placeholder),
      method: "PUT",
      name: this.modelName + '[' + element.attr('data-attribute') + ']',
      indicator : '<img src="/images/loading.gif">',
      onreset: function() {
        $(this).parent().removeClass("editing")
      },
      callback: function(value, settings) {
        var model = JSON.parse(value)
        $(this).attr('data-raw', model[$(this).attr('data-attribute')])
        $(this).html(model[($(this).attr('data-raw-attribute') || $(this).attr('data-attribute'))])
        $(this).removeClass("editing")
      }
    })
  },
  
  positionButtons: function() {
    element = $(this)
    var form = element.parents('form')
    var submit = form.find('button[type=submit]')
    var cancel = form.find('button[type=cancel]')
    var left = element.offset().left + element.width()
    var top = element.offset().top + element.height() + 4
		submit.css('position', 'relative')
		submit.css('display', 'inline')
		cancel.css('position','relative')
		cancel.css('display', 'inline')
  },
  
  keydown: function(event) {
    if (event.keyCode == '13' && $(this).parents('.editable').attr('data-singleline')) {
      event.preventDefault()
      $(this).parents('form').find('button[type=submit]').click()
      return false
    }  
  },
  
  collectionName: function() {
    return this.modelName + 's'
  },
  
  updateUrl: function() {
    return "/" + app.locale + "/" + this.collectionName() + "/" + this.el.attr('data-id') + '.json'
  },
  
  dataRaw: function(){ return $(this).attr('data-raw') }
  
})
