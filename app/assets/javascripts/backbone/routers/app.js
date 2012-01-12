App.Router = Backbone.Router.extend({

    routes: {
        "continue_idea": "loadIdeaFromStore",
        "/login": "loginAction",
        "/idea/new": "newIdeaBox"
    },

    // You can let these functions empty
    // and bind the routes in the view.
    // Nevertheless you still need to define them.
    ideaBox: function () {
    },

    loginAction: function () {
        $.facebox({ div: "#login" });
    },

    newIdeaBox: function () {
        $.facebox({ div: "#start" });
    },

    loadIdeaFromStore: function () {
        App.Ideas.newIdea.openIdeaForm();
    }
});
