module MachineReadableMetadataHelper
  def machine_readable_metadata(content_item, args)
    locals = { content_item: content_item.to_h }.merge(args)
    render("govuk_publishing_components/components/machine_readable_metadata", locals)
  end
end
