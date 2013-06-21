require 'indexable_support_page'

class IndexableSupportPageSet
  def pages
    all_files = Dir.glob("#{Rails.root}/app/views/support/**.erb")
    files_to_index = all_files.reject { |file| file =~ /index\.html\.erb/ }
    files_to_index.map do |filename|
      IndexableSupportPage.new(filename)
    end
  end
end
