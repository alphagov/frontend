class Guide < ContentItem
  include Parts

  def is_evisa?
    base_path == "/evisa"
  end
end
