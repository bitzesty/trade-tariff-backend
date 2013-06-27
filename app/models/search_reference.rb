class SearchReference < Sequel::Model
  include Tire::Model::Search

  plugin :tire

  HEADING_IDENTITY_REGEX = /(\d{1,2}).(\d{1,2})/
  CHAPTER_IDENTITY_REGEX = /Chapter (\d{1,2})|Ch (\d{1,2})|^\s{0,}\d{1,2}\s{0,}$/
  SECTION_IDENTITY_REGEX = /Section\s{1,}(\d{1,2})|section\s{1,}(\d{1,2})/

  tire do
    index_name    'search_references'
    document_type 'search_reference'

    mapping do
      indexes :title,     type: :string, analyzer: :snowball
      indexes :reference, type: :nested
    end
  end

  def referenced_entity
    @referenced_entity ||= case reference
                           when HEADING_IDENTITY_REGEX
                             Heading.by_code("#{$1}#{$2}").first
                           when CHAPTER_IDENTITY_REGEX
                             Chapter.by_code($1).first
                           when SECTION_IDENTITY_REGEX
                             Section.where(position: $1).first
                           else
                             # unprocessable
                           end
  end

  def to_indexed_json
    # Cannot return nil from #to_indexed_json because ElasticSearch does not like that.
    # It will eat all memory and timeout indexing requests.
    result = if referenced_entity.blank?
               {}
             else
               {
                 title: title,
                 reference: referenced_entity.serializable_hash.merge({class: referenced_entity.class.name})
               }
             end

    result.to_json
  end
end
