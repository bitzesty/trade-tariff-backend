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
    Commodity.tire.search(q.presence || "", page: page.presence || 1,
                                            per_page: PER_PAGE)
  end

  def persisted?
    false
  end
end
