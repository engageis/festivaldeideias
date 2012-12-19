App.Ideas.Show = App.EditableView.extend({
    initialize: function () {
        collaborationsForm = new App.Collaborations.Form();
        this.modelName = 'idea';
        this.prepareEditables();
        $(document).bind('afterClose.facebox', function () {
            Backbone.history.navigate('');
        });
    }
});
