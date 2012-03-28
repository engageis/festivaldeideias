App.EditableView = App.BaseView.extend({

  initialize: function() {
    this.prepareEditables()
  },

  prepareEditables: function() {
    _.bindAll(this, "prepareEditable", "updateUrl")
    if(App.editable){
      $.fn.editable.defaults.tooltip = App.editable.defaults.tooltip;
      $.fn.editable.defaults.submit = App.editable.defaults.submit;
      $.fn.editable.defaults.cancel = App.editable.defaults.cancel;
      $.fn.editable.defaults.onblur = App.editable.defaults.onblur;
    }

    this.$('.editable textarea').live('keydown', function() {
      if(!$(this).attr('data-prepared')) {
        $(this).attr('maxlength', $(this).parents('.editable').attr('data-maxlength'))
        //$(this).maxlength()
        //var space = ($(this).parents('.editable').attr('data-singleline')) ? 0 : 100
        //$(this).autoResize({ extraSpace: space })
        $(this).attr('data-prepared', true)
      }
    })
    this.$('.editable textarea').live('focus', this.positionButtons)
    this.$('.editable textarea').live('keyup', this.positionButtons)
    this.$('.editable textarea').live('keydown', this.keydown)
    this.$('.editable').each(this.prepareEditable)
  },

  prepareEditable: function(index, element) {
    //console.log(element)
    self = this;
    element = $(element)
    element.click(function(){
      $(this).addClass("editing")
    })
    element.editable(this.updateUrl(element), {
      data: function(value, settings){
        return $(this).attr('data-raw')
      },
      type: (element.attr('data-type') || "textarea"),
      placeholder: element.attr('data-placeholder'),
      method: "PUT",
      name: this.modelName + '[' + element.attr('data-attribute') + ']',
      indicator : '<img src="/assets/loading.gif">',
      onreset: function() {
        $(this).parents().removeClass("editing")
      },
      callback: function(value, settings) {
        var model = JSON.parse(value)
        $(this).attr('data-raw', model[$(this).attr('data-attribute')])
        $(this).html(model[$(this).attr('data-raw-attribute') || $(this).attr('data-attribute')])
        $(this).removeClass("editing")
        $('.editable').each(self.prepareEditable)
      }
    })
  },

  positionButtons: function() {
    element = $(this)
    var form = element.parents('form')
    var submit = form.find('button[type=submit]')
    var cancel = form.find('button[type=cancel]')
		submit.css('position', 'relative')
		submit.css('display', 'inline')
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

  updateUrl: function(element) {return $(element).attr('data-url') + '.json' },

  dataRaw: function(){ return $(this).attr('data-raw') }

})


