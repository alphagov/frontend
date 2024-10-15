class GetInvolvedController < ContentItemsController
    def show
        puts "Content Item 123"
        puts @content_item.document_type
        puts @content_item.take_part_pages
    end
end