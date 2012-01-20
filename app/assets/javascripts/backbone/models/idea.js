App.Models.Idea = Backbone.Model.extend({

  url: '',

  defaults: {
    title: "",
    headline: "",
  },

  initialize: function(){
    this.url = $('.editable').attr('data-url');
  },

  save: function(){

    var editable = $('.editable[contenteditable=true]');
    var key = editable.attr('data-param');
    var input = editable.text();


    $.ajax({
      type: "PUT",
      dataType: "JSON",
      url: this.url,
      data: {"idea[title]":input},
      success: function(data){
        console.log(data);
      },
      error: function(data){
        console.log(data);
      }
    });
  }
});
