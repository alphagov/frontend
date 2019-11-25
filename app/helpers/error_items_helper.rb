module ErrorItemsHelper
  def error_items(field)
    if flash[:validation] && flash[:validation].select { |key| key.to_s.match(field) }.any?
      sanitize(flash[:validation]
        .select { |key| key.to_s.match(field) }
        .map { |error| error[:text] }
        .join("<br>"))
    end
  end
end
