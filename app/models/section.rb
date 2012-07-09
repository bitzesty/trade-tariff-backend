class Section < ActiveRecord::Base
  has_and_belongs_to_many :chapters, association_foreign_key: :goods_nomenclature_sid
end
