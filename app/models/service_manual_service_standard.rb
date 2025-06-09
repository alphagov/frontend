class ServiceManualServiceStandard < ContentItem
  def initialize(content_store_response)
    super(content_store_response)

    @links = content_store_response["links"]
  end

  def points
    Point.load(points_attributes).sort
  end

private

  def points_attributes
    @points_attributes ||= @links["children"] || []
  end

  class Point
    include Comparable

    attr_reader :title, :description, :base_path

    def self.load(points_attributes)
      points_attributes.map { |point_attributes| new(point_attributes) }
    end

    def initialize(attributes, *_args)
      @title = attributes["title"]
      @description = attributes["description"]
      @base_path = attributes["base_path"]
    end

    def <=>(other)
      number <=> other.number
    end

    def title_without_number
      @title_without_number ||= title.sub(/\A(\d*)\.(\s*)/, "")
    end

    def number
      @number ||= Integer(title.scan(/\A(\d*)/)[0][0])
    end
  end
end
