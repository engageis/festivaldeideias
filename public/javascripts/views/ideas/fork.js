var ForkIdeaView = PopupView.extend({

  el: $('#fork_idea'),

  events: {
    "click [type=checkbox], [type=radio]": "validate"
  },
  
  validate: function() {
    this.$("[type=submit]").attr('disabled', true)
    if(this.$("[type=checkbox]:checked").length != this.$("[type=checkbox]").length)
      return
    this.$("[type=submit]").attr('disabled', false)
  }

})
