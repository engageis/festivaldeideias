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
            //,"updateCharactersLeft"
            ,"focusOnDescription"
            ,"clearAll"
            ,"setRedirectUrl"
            ,"showFbh"
            ,"showFbl"
            ,"validateFblForm"
            ,"checkRequiredFields"
        );
        this.store = new Store('store');
        this.lastPosition = 0;
        //this.loadIdeaFromStore();
    },

    events: {
        "click a[href='#describe']": 'showDescription',
        "click a[href='#refine']": 'showRefinement',
        "click a[href='#publish']": 'showPublishing',
        "click .popup #refine .categories li": "selectCategory",
        "blur .popup input": "updateStore",
        "blur .popup textarea": "updateStore",
        "click a.start[href=#start]": "loadIdeaFromStore",
        "keyup .popup #idea_description": "updateLinkColors",
        "keyup .popup #idea_headline": "updateLinkColors",
        "keyup .popup #idea_title": "updateLinkColors",
        "click .popup .categories li": "updateLinkColors",
        //"keydown .popup #idea_headline": "updateCharactersLeft",
        //"keyup .popup #idea_headline": "updateCharactersLeft",
        "click .popup #refine blockquote": "focusOnDescription",
        "submit .popup form.new_idea": "checkForm",
        "click .popup img.close_image": "clearAll",
        "click a.start[href=#login]": "setRedirectUrl",
        "click .popup #fbl a[href=#fbh]": "showFbh",
        "click .popup #fbh a[href=#fbl]": "showFbl",
        "click .popup #fbh a[href=#login]": "showFbl",
        "click .popup #fbh input[type=submit]": "validateFblForm",
        "click .popup .next": "checkRequiredFields",
        "click .terms_acceptance_link label": "toggleTermsCheckbox",
        "change .terms_acceptance_link input": "changePublishButton"
    },

    changePublishButton: function (e) {
        var checkbox, submit;
        checkbox = $(e.target);
        submit = $('.popup #new_idea input[type=submit]');
        if (this.userHasAccepted()) {
            submit.removeClass('inactive');
        } else {
            submit.addClass('inactive');
        }
    },

    toggleTermsCheckbox: function (e) {
        var checkbox;
        if (e.target.tagName === 'A') {
            return;
        } else {
            checkbox = $(e.target).siblings('input');
            checkbox.attr("checked", !checkbox.attr("checked"));
        }
    },

    checkRequiredFields: function (e) {
        var target, href, me;
        me = this;
        target = $(e.target);
        href = target.attr('href');
        if (href === '#refine') {
            if (!this.canGoToRefinement()) {
                this.showAlert($('.popup #idea_description'));
            }
        } else if (href === '#publish') {
            if (!this.hasCategory()) {
                this.showAlert($('.popup .categories'));
            }
            if (!this.hasTitle()) {
                this.showAlert($('.popup #idea_title'));
            }
        }
    },

    showAlert: function (obj) {
        // TODO: resolver isto;
        obj.addClass('error');
        setTimeout(function () {
            obj.removeClass('error');
        }, 2000);
    },

    goToLastOpenTab: function () {
        var method = 'showDescription';
        switch (this.lastPosition) {
            case 1:
            if (this.canGoToRefinement()) {
                method = 'showRefinement';
            }
            break;
            case 2:
            if (this.canGoToPublishing()) {
                method = 'showPublishing';
            }
            break;
        }
        this[method]();
    },

    showDescription: function () {
        var box = $('.popup');
        box.find("#refine").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#describe").removeClass('hidden');
        this.updateActiveLink('describe');
        this.lastPosition = 0;
    },

    focusOnDescription: function () {
        this.showDescription();
        $('.popup #idea_description').focus();
        this.lastPosition = 0;
    },

    showRefinement: function () {
        var box, descriptionText;
        if (!this.canGoToRefinement()) {
            return false;
        }
        box = $('.popup');
        descriptionText = box.find("#describe").addClass('hidden').find('#idea_description').val();
        box.find("#publish").addClass('hidden');
        box.find("#refine").removeClass('hidden').find('blockquote p').text(descriptionText);
        this.updateActiveLink('refine');
        //this.updateCharactersLeft();
        this.lastPosition = 1;
    },

    showPublishing: function () {
        var box;
        if (!this.canGoToPublishing()) {
            return false;
        }
        box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#refine").addClass('hidden');
        box.find("#publish").removeClass('hidden');
        this.updateActiveLink('publish');
        this.updatePublishingFields();
        this.lastPosition = 2;
    },

    updateActiveLink: function (link) {
        var lis = $('.popup .short_cuts li');
        lis.removeClass('active');
        lis.filter(function () {
            return $(this).find('a[href=#'+link+']').size() > 0;
        }).addClass('active');
        this.updateLinkColors();
    },

    canGoToRefinement: function () {
        return this.hasDescription();
    },

    canGoToPublishing: function () {
        return !(!this.hasDescription() || !this.hasCategory() || !this.hasTitle());
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
        this.updateLinkColors();
    },

    updateLinkColors: function () {
        var links = $('.popup .short_cuts li');
        links.removeClass('blue_link');
        links.eq(0).addClass('blue_link');
        if (this.canGoToRefinement()) {
            links.eq(1).addClass('blue_link');
        }
        if (this.canGoToPublishing()) {
            links.eq(2).addClass('blue_link');
        }
    },

    openIdeaForm: function () {
        $.facebox({ div: '#start' });
        this.loadIdeaFromStore();
        return false;
    },

    loadIdeaFromStore: function () {
        var box, form, s, category_id;
        box = $('.popup');
        form = box.find('form');
        s = this.store;
        form.find('#idea_description').val(s.get('description'));
        form.find('#idea_headline').val(s.get('headline'));
        form.find('#idea_title').val(s.get('title'));
        category = s.get('category');
        form.find('.categories :radio').filter(function () {
            return this.value === category;
        }).prop('checked', true);
        this.bindClearToCloseButton(box);
        this.goToLastOpenTab();
        this.updateLinkColors();
    },

    bindClearToCloseButton: function (box) {
        var me = this;
        box.find('a.close').click(function () {
            me.clearAll();
        });
    },

    userHasAccepted: function () {
        // Verifica se todos o checkboxes dos termos estão selecionados.
        return $('.popup .terms_acceptance_link input[type=checkbox]').not(':checked').length === 0;
    },

    formIsValid: function () {
        return (
            this.userHasAccepted() && this.hasTitle() &&
            this.hasCategory()     && this.hasDescription()
        );
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
        //this.store.removeAll();
        //this.loadIdeaFromStore();
        //this.updatePublishingFields();
    },

    setRedirectUrl: function (e) {
        var target = e.target;
        if ((target && $(target).data('return-url') === '#continue_idea') || e === '#continue_idea') {
            var field, value;
            field = $('.popup').find('#redirect_url');
            value = field.val();
            field.val(value + '#continue_idea');
        }
    },

    showFbh: function () {
        var box;
        box = $('.popup');
        box.find('#fbl').addClass('hidden');
        box.find('#fbh').removeClass('hidden');
        return false;
    },

    showFbl: function () {
        var box;
        box = $('.popup');
        box.find('#fbh').addClass('hidden');
        box.find('#fbl').removeClass('hidden');
        return false;
    },

    validateFblForm: function () {
        return (jQuery.trim($('.popup #fbh #non_facebook_user_email').val()).length > 0);
    }
});
