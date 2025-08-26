module ContentItemLoaders
  # Thrown if a loader said that it was able to load but failed during the process
  class UnableToLoad < StandardError; end
end
