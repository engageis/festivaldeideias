App.Ideas.Common = App.BaseView.extend({
    initialize: function () {
        _.bindAll(
            this,
            "showDescription",
            "showRefinement",
            "showPublishing",
            "updateActiveLink",
            "updatePublishingFields"
        );
    },

    events: {
        "click a[href='#describe']": 'showDescription',
        "click a[href='#refine']": 'showRefinement',
        "click a[href='#publish']": 'showPublishing',
        "click .popup a": "updateActiveLink"
    },

    showDescription: function () {
        var box = $('.popup');
        box.find("#refine").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#describe").removeClass('hidden');
    },

    showRefinement: function () {
        var box;
        if (!this.hasDescription()) return false;
        box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#refine").removeClass('hidden');
    },

    showPublishing: function () {
        var box;
        if (!this.hasDescription()) return false;
        box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#refine").addClass('hidden');
        box.find("#publish").removeClass('hidden');
        this.updatePublishingFields();
    },

    updateActiveLink: function (e) {
        var shortcuts, hash;
        if (!this.hasDescription()) return false;
        shortcuts = $('.popup .short_cuts a');
        hash = e.target.hash;
        shortcuts.each(function () {
            if (this.hash === hash) {
                $(this).parent().addClass('active');
            } else {
                $(this).parent().removeClass('active');
            }
        });
    },

    hasDescription: function () {
        return jQuery.trim($('.popup').find('#idea_description').val()).length > 0;
    },

    updatePublishingFields: function () {
        var form, description, title, headline, publish;
        form = $('.popup').find('form');
        publish = form.find('#publish');
        categoryImage = form.find('#refine .categories').find(':radio:checked').parent().find('img').attr('src');
        description = form.find('#idea_description').val();
        title = form.find('#idea_title').val();
        headline = form.find('#idea_headline').val();
        publish.find('.title').text(title);
        publish.find('.description').text(description);
        publish.find('.headline').text(headline);
        publish.find('.category').attr('src', categoryImage);
    }
});
