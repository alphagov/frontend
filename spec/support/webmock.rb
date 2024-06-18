require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

module WebmockHelper
  def no_web_calls_should_have_been_made
    expect(WebMock).not_to have_requested(:any, /.*/)
  end

  def no_post_calls_should_have_been_made
    expect(WebMock).not_to have_requested(:post, /.*/)
  end
end

RSpec.configuration.include WebmockHelper, type: :feature
