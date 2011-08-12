var ForkIdeaView = PopupView.extend({

  el: $('#fork_idea'),

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
			document.forms["fork_idea"].submit();
		})
  }

})
