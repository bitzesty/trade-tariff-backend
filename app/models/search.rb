class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :q
  attr_reader :results, :exact_match

  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.respond_to?(:"#{name}=")
        send(:"#{name}=", value)
      end
    end if attributes.present?
  end

  alias :exact_match? :exact_match

  def perform
    @results = case q
               when /^[0-9]{1,3}$/
                 Chapter.by_code(q).first
               when /^[0-9]{4,9}$/
                 Heading.by_code(q).first
               when /^[0-9]{10}$/
                 Commodity.by_code(q).declarable.first.presence ||
                 Heading.by_declarable_code(q).first.presence
               when /^[0-9]{12}$/
                 Commodity.by_code(q).declarable.first
               end

    @exact_match = true if results.present?

    # else do elasticsearch

    # sm = SearchMetric.where(q: q, q_on: Date.today).first
    # if sm
    #   sm.inc(:count, 1)
    # else
    #   SearchMetric.create(q: q, q_on: Date.today, results: search.total_entries)
    # end

    # {
    #   entries: search.results.as_json,
    #   current_page: search.current_page,
    #   total_entries: search.total_entries,
    #   per_page: search.per_page,
    #   total_pages: search.total_pages,
    #   offset: search.offset
    # }
    self
  end

  def to_json(config = {})
    if exact_match?
      {
        type: "exact_match",
        entries: [{
          endpoint: @results.class.name.parameterize("_").pluralize,
          id: @results.identifier
        }]
      }.to_json
    else
      {
        type: "fuzzy_match",
        entries: [{
        }]
      }.to_json
    end
  end

  def persisted?
    false
  end
end
