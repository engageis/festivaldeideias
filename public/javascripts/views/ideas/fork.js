var ForkIdeaView = PopupView.extend({

  el: $('#fork_idea'),

  events: {
    "click [type=checkbox], [type=radio]": "validate",
    "submit form": "beforeSubmit"
  },
  
  beforeSubmit: function(event) {
    location.href = '#confirm_fork'
    event.preventDefault()
    return false
  },
  
  beforeRender: function() {
    this.$("[type=submit]").attr('disabled', true)
    this.$("[type=checkbox]").attr('checked', false)
  },

  validate: function() {
    this.$("[type=submit]").attr('disabled', true)
    if(this.$("[type=checkbox]:checked").length != this.$("[type=checkbox]").length)
      return
    this.$("[type=submit]").attr('disabled', false)
  }

})
