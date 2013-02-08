class GoodsNomenclatureGroupValidator < TradeTariffBackend::Validator
  validation :NA1, 'The combination type and group code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:goods_nomenclature_group_id, :goods_nomenclature_group_type]
  end

  validation :NG2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
