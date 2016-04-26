describe('A click tracker', function() {
  "use strict";

  var tracker,
      element;

  beforeEach(function() {
    GOVUK.analytics = {trackEvent: function() {}};
    tracker = new GOVUK.Modules.TrackClick();
  });

  afterEach(function() {
    delete GOVUK.analytics;
  });

  it('tracks click events', function() {
    spyOn(GOVUK.analytics, 'trackEvent');

    element = $('\
      <div \
        data-track-category="category"\
        data-track-action="action"\
        data-track-label="Foo">\
        Bar!\
      </div>\
    ');

    tracker.start(element);

    element.trigger('click');

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('category', 'action', {label: 'Foo'});
  });
});
