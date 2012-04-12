App.Router = Backbone.Router.extend({

    routes: {
        "colaborate" : "colaborate",
        "continue_idea": "loadIdeaFromStore"
    },

    loadIdeaFromStore: function () {
        App.Ideas.newIdea.openIdeaForm();
    }
});
