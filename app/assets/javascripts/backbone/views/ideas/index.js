App.Ideas.Index = App.BaseView.extend({

    // TODO: Dar um jeito dos valores dos campos
    // ficarem preservados quando o facebox fecha.
    // Ainda não pensei como...

    initialize: function () {
        _.bindAll(
            this,
            "showStep1",
            "showStep2",
            "showStep3"
        );
    },

    events: {
        "click .popup .step_1 a.next": "showStep2",
        "click .popup .step_2 a.next": "showStep3",
        "click .popup a.volta_1": "showStep1",
        "click .popup a.volta_2": "showStep2",
    },

    showStep1: function () {
        var box = $('.popup');
        box.find('.step_2').addClass("hidden");
        box.find('.step_3').addClass("hidden");
        box.find('.step_1').removeClass("hidden");
    },

    showStep2: function () {
        var box = $('.popup');
        box.find('.step_1').addClass("hidden");
        box.find('.step_3').addClass("hidden");
        box.find('.step_2').removeClass("hidden");
    },

    showStep3: function () {
        var box = $('.popup');
        box.find('.step_1').addClass("hidden");
        box.find('.step_2').addClass("hidden");
        box.find('.step_3').removeClass("hidden");
    }
});
