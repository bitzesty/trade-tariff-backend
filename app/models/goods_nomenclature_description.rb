require 'time_machine'
require 'formatter'

class GoodsNomenclatureDescription < Sequel::Model
  include Formatter

  plugin :time_machine
  plugin :oplog, primary_key: [:goods_nomenclature_sid,
                               :goods_nomenclature_description_period_sid]
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_sid, :goods_nomenclature_description_period_sid]

  one_to_one :goods_nomenclature, primary_key: :goods_nomenclature_sid, key: :goods_nomenclature_sid

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description

  def formatted_description
    super.mb_chars.downcase.to_s.gsub(/^(.)/) { $1.capitalize }
  end

  def to_s
    description
  end
end
