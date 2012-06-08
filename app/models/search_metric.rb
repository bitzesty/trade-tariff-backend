class SearchMetric
  include Mongoid::Document

  field :q,       type: String
  field :q_on,    type: Date
  field :count,   type: Integer, default: 1
  field :results, type: Integer, default: 0
end
