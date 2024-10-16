class GetInvolvedController < ContentItemsController
    
    def show    
        puts "Content Item show" 
    end
   
    def content_item
      puts "In content item method Get Involved controller"      
      @content_item ||= ContentItemFactory.build(request_content_item(content_item_slug || "/#{params[:slug]}"))
    end
end