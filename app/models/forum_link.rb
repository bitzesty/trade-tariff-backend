class ForumLink < Sequel::Model
  plugin :timestamps

  one_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                  foreign_key: :goods_nomenclature_sid
end
