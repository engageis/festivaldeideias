var MergeIdeaView = PopupView.extend({

  el: $('#merge_idea'),

  events: {
    "submit form": "disableSubmit"
  },

  beforeRender: function() {
    this.$('#from_id').val(this.fromId)
  }
  
})
