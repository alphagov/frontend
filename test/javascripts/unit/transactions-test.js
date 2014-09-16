// Stub analytics
var _gaq = { push : function(args) { } };

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
      spyOn(_gaq, 'push');

      window.GOVUK.Transactions.trackStartPageTabs({ target : { href : location.href + '#foo' } });

      expect(_gaq.push).toHaveBeenCalled();

      var calledWith = _gaq.push.mostRecentCall.args[0];
      expect(calledWith[1]).toEqual('startpages');
      expect(calledWith[2]).toEqual('tab');
      expect(calledWith[3]).toEqual(location.href + "#foo");
    });

  });
});
