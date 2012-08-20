class SearchReference < Sequel::Model
  include Tire::Model::Search

  HEADING_IDENTITY_REGEX = /(\d{1,2}).(\d{1,2})/
  CHAPTER_IDENTITY_REGEX = /Chapter (\d{1,2})|Ch (\d{1,2})|\s{0,}\d{1,2}\s{0,}/
  SECTION_IDENTITY_REGEX = /Section\s{1,}(\d{1,2})|section\s{1,}(\d{1,2})/

  tire do
    index_name    'search_references'
    document_type 'search_reference'

    mapping do
      indexes :title,        index: :not_analyzed
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
    {
      title: title,
      reference: referenced_entity.serializable_hash.merge({class: referenced_entity.class.name})
    }.to_json unless referenced_entity.blank?
  end
end
