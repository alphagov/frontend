describe('GOVUK.taxDiscBetaPrimary', function () {
  var taxDiscHtml, $taxDiscHtml;
  beforeEach(function () {
    taxDiscHtml = ' \
      <section class="primary-apply"><p>DVLA</p></section> \
      <section class="secondary-apply"><p>BETA</p></section> \
      <script id="beta-primary" type="text/plain"><p>BETA</p></script> \
      <script id="dvla-secondary" type="text/plain"><p>DVLA</p></script> \
    ';
    $taxDiscHtml = $(taxDiscHtml);
    $('body').append($taxDiscHtml);
  });
  afterEach(function () {
    $taxDiscHtml.remove();
  });
  it('should replace the primary application markup with the beta markup', function () {
    GOVUK.taxDiscBetaPrimary();
    expect($('.primary-apply').text()).toEqual('BETA');
    expect($('.secondary-apply').text()).toEqual('DVLA');
  });
});
