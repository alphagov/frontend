require_relative '../test_helper'

class RedirectWardenTest < ActiveSupport::TestCase

  setup do
    @redirect_warden = RedirectWardenFactory.new
  end

  def link_markup(target, text ='Text', title='Title')
    "[#{text}](#{target} #{title})"
  end

  context 'error handling' do
    should "return nil if publication is nil" do
      assert @redirect_warden.for(@publication).nil?
    end
  end

  context 'transaction format' do

    setup do
      @type = 'transaction'

      @publication = OpenStruct.new(:type => @type, :link => '', :more_information => '')
    end

    should "have a warden" do
      assert @redirect_warden.for(@publication)
    end

    should "pass if link is in publication.link" do
      target = 'http://example.com'
      @publication.link = target

      assert @redirect_warden.for(@publication).call(target)
    end

    should "pass if link is in publication.more_infomation" do
      target = 'http://example.com'
      @publication.more_information = "   #{link_markup(target)}   "

      assert @redirect_warden.for(@publication).call(target)
    end

    should "pass if link is in publication.minutes_to_complete" do
      target = 'http://example.com'
      @publication.minutes_to_complete = "   #{link_markup(target)}   "

      assert @redirect_warden.for(@publication).call(target)
    end

    should "pass if link is in publication.alternate_methods" do
      target = 'http://example.com'
      @publication.alternate_methods = "   #{link_markup(target)}   "

      assert @redirect_warden.for(@publication).call(target)
    end

    should "not pass, if link is not in publication" do
      target = 'http://evil.com'
      @publication.link = "http://nice-guys-inc.com"

      assert !@redirect_warden.for(@publication).call(target)
    end
  end

  context 'guide format' do
    setup do
      @type = 'guide'
      @parts = []
      @publication = OpenStruct.new(:type => @type, :parts => @parts)
    end

    def body content
      OpenStruct.new(:body => content)
    end

    should "have a warden" do
      assert @redirect_warden.for(@publication)
    end

    should "pass if a body has the link" do
      target = 'http://example.com'
      @parts << body("daflkdsajf dsafjalds asdlfjkl")
      @parts << body("askdjfh asdfkh #{link_markup(target)}")
      @parts << body("dakkl ???")

      assert @redirect_warden.for(@publication).call(target)
    end

    should "pass if link is video url" do
      target = 'http://example.com/video'
      @publication.video_url = target

      assert @redirect_warden.for(@publication).call(target)
    end

    should "not pass if no body has the link" do
      target = 'http://evil.com'
      @parts << body("daflkdsajf dsafjalds asdlfjkl")
      @parts << body("askdjfh asdfkh #{link_markup('http://example.com')}")
      @parts << body("dakkl ???")

      assert !@redirect_warden.for(@publication).call(target)

    end
  end

  context 'programme (benefits & credits) format' do
    setup do
      @type = 'programme'
      @parts = []
      @publication = OpenStruct.new(:type => @type, :parts => @parts)
    end

    def body content
      OpenStruct.new(:body => content)
    end

    should "have a warden" do
      assert @redirect_warden.for(@publication)
    end

    should "pass if a body has the link" do
      target = 'http://example.com'
      @parts << body("daflkdsajf dsafjalds asdlfjkl")
      @parts << body("askdjfh asdfkh #{link_markup(target)}")
      @parts << body("dakkl ???")

      assert @redirect_warden.for(@publication).call(target)
    end

    should "not pass if no body has the link" do
      target = 'http://evil.com'
      @parts << body("daflkdsajf dsafjalds asdlfjkl")
      @parts << body("askdjfh asdfkh #{link_markup('http://example.com')}")
      @parts << body("dakkl ???")

      assert !@redirect_warden.for(@publication).call(target)
    end
  end

  context 'answer (quick answer) format' do
    setup do
      @type = 'answer'
      @publication = OpenStruct.new(:type => @type, :body => "")
    end

    should "have a warden" do
      assert @redirect_warden.for(@publication)
    end

    should "pass if the body has the link" do
      target = 'http://example.com'
      @publication.body = "Lawful sports and past times #{link_markup(target)}"

      assert @redirect_warden.for(@publication).call(target)
    end

    should "not pass if no body has the link" do
      target = 'http://evil.com'
      @publication.body = "Lawful sports and past times #{link_markup("http://example.com")}"

      assert !@redirect_warden.for(@publication).call(target)
    end
  end
end