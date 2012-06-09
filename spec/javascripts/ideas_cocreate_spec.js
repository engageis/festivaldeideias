describe("Ideas#Cocreate", function(){
 
  TB      = { 
    initSession: function(){}, 
    setLogLevel: function(){}, 
    addEventListener: function(){ return true } 
  }
  pusher  = new Pusher('3e107fc25d5330b3338b');
  list    = $('<ul/>').attr('class', 'msglist');
  app     = new App.Ideas.Cocreate({ el: $('body')[0] });
  describe(".initializePusher", function(){
    beforeEach(function(){
      spyOn(pusher, "subscribe");
      spyOn(list, "scrollTop");
    });
  
   
    it("Should subscribe the user to a pusher channel", function(){
      expect(pusher.subscribe).toHaveBeenCalled();
      expect(list.scrollTop).toHaveBeenCalledWith(list.prop("scrollHeight"));
    });
  });

});
