module Api
  module V2
    module Changes
      class HeadingSerializer
        include JSONAPI::Serializer

        set_type :heading

        set_id :goods_nomenclature_sid

        attributes :description, :goods_nomenclature_item_id, :validity_start_date, :validity_end_date
      end
    end
  end
end
