App.Ideas.Show = App.EditableView.extend({
    initialize: function () {
        collaborationsForm = new App.Collaborations.Show();
        this.modelName = 'idea';
        this.prepareEditables();
        $(document).bind('afterClose.facebox', function () {
            Backbone.history.navigate('');
        });
    }
});
