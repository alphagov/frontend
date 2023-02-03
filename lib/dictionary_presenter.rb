class DictionaryPresenter
  def initialize(collection)
    @collection = collection
  end

  def as_dictionary
    dictionary = ("A".."Z").index_with { |_l| [] }

    @collection.each do |p|
      dictionary[p.title[0]] << p
    end

    dictionary
  end
end
