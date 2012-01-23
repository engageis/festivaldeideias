App.Router = Backbone.Router.extend({

    routes: {
        "continue_idea": "loadIdeaFromStore",
        //"login": "loginAction", // Acaba acontencendo duas vezes, por causa do router e por causa do evento
    },

    // You can let these functions empty
    // and bind the routes in the view.
    // Nevertheless you still need to define them.
    ideaBox: function () {
    },

    loginAction: function () {
        $.facebox({ div: "#login" });
    },

    loadIdeaFromStore: function () {
        App.Ideas.newIdea.openIdeaForm();
    }
});
