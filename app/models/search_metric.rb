class SearchMetric
  include Mongoid::Document

  field :q,     type: String
  field :q_on,  type: Date
  field :count, type: Integer
end
