class Condition
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          type: String
  field :document_code, type: String
  field :action,        type: String
  field :duty_expression,        type: String

  has_and_belongs_to_many :measures
end
