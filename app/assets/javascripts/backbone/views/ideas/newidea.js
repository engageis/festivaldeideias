App.Ideas.NewIdea = App.BaseView.extend({
    initialize: function () {
        _.bindAll(this
                ,"showDescription"
                ,"showRefinement"
                ,"showPublishing"
                ,"updateActiveLink"
                ,"updatePublishingFields"
                ,"selectCategory"
                ,"updateStore"
                ,"openIdeaForm"
            );
        var me = this;
        //$('.popup form').on('load', function () {
            //alert("Loaded");
            //me.loadIdeaFromStore();
        //});
        this.store = new Store('store');
        this.loadIdeaFromStore();
    },

    events: {
        "click a[href='#describe']": 'showDescription',
        "click a[href='#refine']": 'showRefinement',
        "click a[href='#publish']": 'showPublishing',
        "click .popup a": "updateActiveLink",
        "click .popup #refine .categories li": "selectCategory",
        "blur .popup input": "updateStore",
        "blur .popup textarea": "updateStore",
        "click a.start[href=#start]": "loadIdeaFromStore"
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

    selectCategory: function (e) {
        var clickedListItem, target;
        target = e.target;
        if (target.tagName === 'LI') {
            clickedListItem = $(target);
        } else {
            clickedListItem = $(target).parents('li');
        }
        clickedListItem.find(':radio').prop('checked', true);
        this.updateStore();
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
    },

    updateStore: function () {
        var form, s;
        form = $('.popup').find('form');
        s = this.store;
        s.set('description', form.find('#idea_description').val());
        s.set('headline', form.find('#idea_headline').val());
        s.set('category', form.find('.categories :radio:checked').val());
        s.set('title', form.find('#idea_title').val());
    },

    openIdeaForm: function () {
        $.facebox({ div: '#start' });
        this.loadIdeaFromStore();
        return false;
    },

    loadIdeaFromStore: function () {
        var form, s, category_id;
        form = $('.popup').find('form');
        s = this.store;
        form.find('#idea_description').val(s.get('description'));
        form.find('#idea_headline').val(s.get('headline'));
        form.find('#idea_title').val(s.get('title'));
        category = s.get('category');
        form.find('.categories :radio').filter(function () {
            return this.value === category;
        }).prop('checked', true);
    },

    clearAll: function () {
        this.store.clearAll();
        this.loadIdeaFromStore();
    }
});
