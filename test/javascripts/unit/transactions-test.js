describe("Transactions", function () {

  describe("trackStartPageTabs", function () {
    var $tabs;

    beforeEach(function () {
      $tabs = $('<div class="transaction"><div class="nav-tabs"><a href="#foo">Foo</a></div></div>');
      $('body').append($tabs);
    });

    afterEach(function(){
      $tabs.remove();
    });

    it("pushes a page path including anchor", function () {
      GOVUK.analytics = GOVUK.analytics || { trackEvent : function(args) {} };
      spyOn(GOVUK.analytics, 'trackEvent');

      window.GOVUK.Transactions.trackStartPageTabs({ target : { href : location.href + '#foo' } });

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalled();

      var calledWith = GOVUK.analytics.trackEvent.mostRecentCall.args;
      expect(calledWith[0]).toEqual('startpages');
      expect(calledWith[1]).toEqual('tab');
      expect(calledWith[2]).toEqual({label: location.href + "#foo", nonInteraction: true});
    });

  });
});
