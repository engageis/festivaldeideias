var ConfirmForkView = PopupView.extend({
  
  el: $('#confirm_fork_idea'),

  events: {
    "click [type=submit]": "submitForm",
    "submit form": "disableSubmit"
  },
  
  submitForm: function() {
		document.forms["fork_idea"].submit();
  }
  
})
