module Programs
  class CollectionPresenter
    include ActiveRecord::Sanitization::ClassMethods

    def initialize(collection, term: nil)
      @collection = collection
      @term = term
    end

    def filtered
      if @term
        filter_collection(@collection)
      else
        @collection
      end
    end

    private

    def filter_collection(collection)
      case @term.size
      when 2
        collection.where("extract_bigrams_tsvector(title) @@ ''?''::tsquery", @term)
      else
        collection.where('title LIKE ?', "%#{sanitize_sql_like(@term)}%")
      end
    end
  end
end
