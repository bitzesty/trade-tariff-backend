class HiddenGoodsNomenclature < Sequel::Model
  plugin :timestamps

  set_dataset order(:goods_code_identifier.asc)

  validates do
    presence_of :goods_code_identifier
  end

  def self.to_pattern
    /^(#{all.map(&:goods_code_identifier).join("|")})/
  end
end
