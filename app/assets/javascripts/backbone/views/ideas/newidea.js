App.Ideas.NewIdea = App.BaseView.extend({
    initialize: function () {
        _.bindAll(this
                ,"showDescription"
                ,"showRefinement"
                ,"showPublishing"
                ,"updatePublishingFields"
                ,"selectCategory"
                ,"updateStore"
                ,"openIdeaForm"
                ,"updateCharactersLeft"
                ,"focusOnDescription"
                ,"clearAll"
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
        "click .popup #refine .categories li": "selectCategory",
        "blur .popup input": "updateStore",
        "blur .popup textarea": "updateStore",
        "click a.start[href=#start]": "loadIdeaFromStore",
        "keydown .popup #idea_headline": "updateCharactersLeft",
        "keyup .popup #idea_headline": "updateCharactersLeft",
        "click .popup #refine blockquote": "focusOnDescription",
        "submit .popup form": "checkForm"
    },

    showDescription: function () {
        var box = $('.popup');
        box.find("#refine").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#describe").removeClass('hidden');
        this.updateActiveLink('describe');
    },

    focusOnDescription: function () {
        this.showDescription();
        $('.popup #idea_description').focus();
    },

    showRefinement: function () {
        var box, descriptionText;
        if (!this.hasDescription()) return false;
        box = $('.popup');
        descriptionText = box.find("#describe").addClass('hidden').find('#idea_description').val();
        box.find("#publish").addClass('hidden');
        box.find("#refine").removeClass('hidden').find('blockquote p').text(descriptionText);
        this.updateActiveLink('refine');
        this.updateCharactersLeft();
    },

    showPublishing: function () {
        var box;
        if (!this.hasDescription() || !this.hasCategory() || !this.hasTitle()) return false;
        box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#refine").addClass('hidden');
        box.find("#publish").removeClass('hidden');
        this.updateActiveLink('publish');
        this.updatePublishingFields();
    },

    updateActiveLink: function (link) {
        var lis = $('.popup .short_cuts li');
        lis.removeClass('active');
        lis.filter(function () {
            return $(this).find('a[href=#'+link+']').size() > 0;
        }).addClass('active');
    },

    hasDescription: function () {
        return jQuery.trim($('.popup').find('#idea_description').val()).length > 0;
    },

    hasCategory: function () {
        return $('.popup').find('.categories :radio:checked').size() > 0;
    },

    hasTitle: function () {
        return $('.popup').find('#idea_title').val().length > 0;
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

    updateCharactersLeft: function (e) {
        var t, c;
        t = this.headline || $('.popup #idea_headline');
        c = this.counter  || $('.popup .char_counter');
        c.text(200 - t.val().length);
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

    formIsValid: function () {
        return this.hasTitle() && this.hasCategory() && this.hasDescription();
    },

    checkForm: function () {
        if (!this.formIsValid()) {
            return false;
        } else {
            this.store.removeAll();
        }
    },

    clearAll: function () {
        this.store.removeAll();
        this.loadIdeaFromStore();
    }
});
