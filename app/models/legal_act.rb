class LegalAct
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String

  has_many :measures

  def url
    number, subnumber = code.match(/(.{5})\/(.{2})/).captures
    "http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:320#{subnumber}#{number}:en:HTML"
  end
end
