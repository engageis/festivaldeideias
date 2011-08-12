var RemoveIdeaView = PopupView.extend({

  el: $('#remove_idea'),

  events: {
    "click [type=checkbox], [type=radio]": "validate",
    "submit form": "disableSubmit"
  },

  validate: function() {
    this.$("[type=submit]").attr('disabled', true)
    if(this.$("[type=checkbox]:checked").length != this.$("[type=checkbox]").length)
      return
    this.$("[type=submit]").attr('disabled', false)
		this.$("[type=submit]").click(function () {
			document.forms["remove_idea"].submit();
		})
  }

})
