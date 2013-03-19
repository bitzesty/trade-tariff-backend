class SearchService
  class NullSearch < BaseSearch
    def serializable_hash
      BLANK_RESULT
    end
  end
end
