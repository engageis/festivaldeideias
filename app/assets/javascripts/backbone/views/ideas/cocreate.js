App.Ideas.Cocreate = App.BaseView.extend({
  initialize: function(){
    _.bindAll(this);
    
    // General Settings
    this.chat             = this.$('#chat');
    this.video            = this.$('#cocreation');
    this.channel          = this.chat.data('channel');

    // Pusher
    this.pusherKey        = "3e107fc25d5330b3338b";
    this.chatMsgList      = this.$('ul.msglist');
    this.chatInputField   = this.$('#input_new_message');

    // Tokbox
    this.tokboxKey        = "15793291";
    this.tokboxSession    = this.chat.data('tokbox-session');
    this.tokboxToken      = this.chat.data('tokbox-token');

    this.initializePusher();
  },

  initializePusher: function(){
    var pusher    = new Pusher(this.pusherKey);
    var channel   = pusher.subscribe(this.channel);
    var self      = this;  
    self.chatMsgList.scrollTop(self.chatMsgList.prop("scrollHeight"));
  

    channel.bind('new-message', function(data){
      self.chatInputField.val("");
      
      if (self.chatMsgList.length == 0) {
        var list = $("<ul/>").attr('class', 'msglist');
        $('.nomsg').remove();
        $('.chatmsgs').prepend(list);
        list.append(data.message); 
        self.chatMsgList = list;
      } else {
        self.chatMsgList.append(data.message);
        self.chatMsgList.scrollTop(self.chatMsgList.prop("scrollHeight"));
      }
    });

  },

  initializeTokBox: function(){
    // Uncomment/Comment the line below to activate debug for TokBokx
    TB.setLogLevel(TB.DEBUG); 

    var session = TB.initSession(this.tokboxSession);      
    session.addEventListener('sessionConnected', sessionConnectedHandler);      
    session.addEventListener('streamCreated', streamCreatedHandler);
    session.connect(this.tokboxKey, this.tokboxToken);

    function sessionConnectedHandler(event) {
      publisher = session.publish('cocreation');
    }

    function streamCreatedHandler(event) {
      subscribeToStreams(event.streams);
    }
     
    function subscribeToStreams(streams) {
      for (var i = 0; i < streams.length; i++) {
        if (streams[i].connection.connectionId == session.connection.connectionId) {
          return;
        }

        var div = document.createElement('div');
        div.setAttribute('id', 'stream' + streams[i].streamId);
        this.video.append(div);
                           
        session.subscribe(streams[i], div.id);
      }
    } 
  }
});
