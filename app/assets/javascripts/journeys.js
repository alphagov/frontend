/*
 * Set up stageprompt for journey tracking
 */
$(function() {
    GOVUK.performance.stageprompt
        .setup({
            analyticsFunction: function(msg) {
                _gaq.push(['_trackEvent', msg, '', '']);
            }
        });
});