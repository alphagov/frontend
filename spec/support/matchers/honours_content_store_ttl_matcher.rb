RSpec::Matchers.define :honour_content_store_ttl do
  match do |actual|
    actual.headers["Cache-Control"] == "max-age=#{15.minutes.to_i}, public"
  end
end
