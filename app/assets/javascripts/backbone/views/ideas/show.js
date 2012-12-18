App.Ideas.Show = App.EditableView.extend({
    initialize: function () {
        this.modelName = 'idea';
        this.prepareEditables();
        $(document).bind('afterClose.facebox', function () {
            Backbone.history.navigate('');
        });
    }
});
