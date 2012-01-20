describe("IdeaNewView", function(){


  beforeEach(function(){
    view = new App.Ideas.NewIdea({el: body});
    spyOn($, 'facebox');
    store = {get: function(){}, set: function(){}, remove: function(){}};

  });


});
