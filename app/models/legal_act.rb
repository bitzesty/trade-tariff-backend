class LegalAct
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :url,  type: String

  has_many :measures
end
