class DictionaryPresenter
  def initialize(collection)
    @collection = collection
  end

  def as_dictionary
    dictionary = ('A'..'Z').inject({}) {|h, l| h[l] = []; h}

    @collection.each do |p|
      dictionary[p.title[0]] << p
    end

    dictionary
  end
end