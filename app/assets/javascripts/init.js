// Init the Controller / Action
UTIL = {
  exec: function( controller, action ) {
    var ns = FDI,
        action = ( action === undefined ) ? "init" : action;

    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
      ns[controller][action]();
    }
  },

  init: function() {
    var body = document.body,
        controller = body.getAttribute( "data-controller" ),
        action = body.getAttribute( "data-action" );

    UTIL.exec( "common" );
    UTIL.exec( controller );
    UTIL.exec( controller, action );
    UTIL.exec( "common", "finish" );
  }
};

$( document ).ready( UTIL.init );

