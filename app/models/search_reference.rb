class SearchReference < Sequel::Model
  plugin :active_model
  plugin :tire

  many_to_one :section
  many_to_one :chapter, dataset: -> {
    Chapter.by_code(chapter_id)
  }
  many_to_one :heading, dataset: -> {
    Heading.by_code(heading_id)
  }

  self.raise_on_save_failure = false

  dataset_module do
    def heading_id
      1
    end

    def by_title
      order(Sequel.asc(:title))
    end
  end

  tire do
    index_name    'search_references'
    document_type 'search_reference'

    mapping do
      indexes :title,     type: :string, analyzer: :snowball
      indexes :reference, type: :nested
    end
  end

  def validate
    super

    if heading_id.blank? && chapter_id.blank? && section_id.blank?
      errors.add(:reference, 'has to be associated to Section/Chapter/Heading')
    end
    errors.add(:title, 'missing title') if title.blank?
  end

  def referenced_entity
    heading || chapter || section || NullObject.new
  end

  def reference_class
    referenced_entity.class.name
  end

  def to_indexed_json
    # Cannot return nil from #to_indexed_json because ElasticSearch does not like that.
    # It will eat all memory and timeout indexing requests.
    result = if referenced_entity.blank?
               {}
             else
               {
                 title: title,
                 reference_class: reference_class,
                 reference: referenced_entity.serializable_hash.merge({class: referenced_entity.class.name})
               }
             end

    result.to_json
  end
end
