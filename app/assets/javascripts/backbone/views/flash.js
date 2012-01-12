App.Flash = Backbone.View.extend({
    className: 'flash',

    initialize: function (options) {
        _.bindAll(this, 'close');
        this.el = $(this.el);
        options = $.extend({ timeout: 5000, speed: 'slow' }, options);
        this.speed = options.speed;
        this.timeout = options.timeout;
        this.message = options.message;
        this.el.addClass('notice').addClass('flash');

        // Created dynamically
        if (this.el.parent().length === 0) {
            this.attachItself();
        }

        if (jQuery.trim(this.el.html()).length > 0) {
            this.show();
        }
    },

    show: function () {
        this.el.slideDown(this.speed);
        window.setTimeout(this.close, this.timeout);
    },

    close: function () {
        this.el.slideUp(this.speed);
    },

    attachItself: function () {
        this.el.html(this.message);
        $('.flashes').append(this.el);
    }
});
