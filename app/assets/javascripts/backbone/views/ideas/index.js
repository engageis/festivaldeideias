App.Ideas.Index = App.BaseView.extend({

    // TODO: Dar um jeito dos valores dos campos
    // ficarem preservados quando o facebox fecha.
    // Ainda não pensei como...

    initialize: function () {
        _.bindAll(
            this,
            "showDescription",
            "showRefinement",
            "showPublishing",
            "updateActiveLink"
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
        var box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#publish").addClass('hidden');
        box.find("#refine").removeClass('hidden');
    },

    showPublishing: function () {
        var box = $('.popup');
        box.find("#describe").addClass('hidden');
        box.find("#refine").addClass('hidden');
        box.find("#publish").removeClass('hidden');
    },

    updateActiveLink: function (e) {
        var shorcuts, hash;
        shorcuts = $('.popup .shortcuts a');
        hash = e.target.hash;
        shortcuts.each(function () {
            alert(this.hash);
            if (this.hash === hash) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });
    }
});
