class Search
  PER_PAGE = 25
  ATTRIBUTES = [:q, :page]

  include ActiveModel::Validations
  include ActiveModel::Conversion

  ATTRIBUTES.each do |attribute|
    attr_accessor attribute
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.respond_to?(:"#{name}=")
        send(:"#{name}=", value)
      end
    end if attributes.present?
  end

  def perform
    search = Commodity.tire.search do |search|
      search.query do |query|
       query.string q.presence || ""
      end

      {
        page: self.page.presence || 1,
        per_page: PER_PAGE
      }
    end

    sm = SearchMetric.where(q: q, q_on: Date.today).first
    if sm
      sm.inc(:count, 1)
    else
      SearchMetric.create(q: q, q_on: Date.today)
    end

    {
      entries: search.results.as_json,
      current_page: search.current_page,
      total_entries: search.total_entries,
      per_page: search.per_page,
      total_pages: search.total_pages,
      offset: search.offset
    }
  end

  def persisted?
    false
  end
end
