var NewIdeaView = PopupView.extend({

  el: $('#new_idea'),

  events: {
    "click [type=checkbox], [type=radio]": "validate",
    "keyup [type=text], textarea": "validate",
    "submit form": "disableSubmit"
  },
  
  initialize: function() {
    this.$('textarea').maxlength()
    _.bindAll(this, "render", "disableSubmit")
  },
  
  validate: function() {
    this.$("[type=submit]").attr('disabled', true)
    if(this.$("#idea_title").val().length == 0)
      return
    if(this.$("#idea_headline").val().length == 0)
      return
    if(this.$("[type=radio]:checked").length == 0)
      return
    if(this.$("[type=checkbox]:checked").length != this.$("[type=checkbox]").length)
      return
    this.$("[type=submit]").attr('disabled', false)
  }
  
})
