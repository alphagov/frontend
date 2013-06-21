require 'indexable_support_page'

class IndexableSupportPageSet
  def pages
    Dir.glob("#{Rails.root}/app/views/support/**.erb").map do |filename|
      IndexableSupportPage.new(filename)
    end
  end
end
