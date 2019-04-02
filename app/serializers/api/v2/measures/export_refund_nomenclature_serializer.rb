module Api
  module V2
    module Measures
      class ExportRefundNomenclatureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :export_refund_nomenclature

        set_id :export_refund_nomenclature_sid

        attributes :code, :description
      end
    end
  end
end
