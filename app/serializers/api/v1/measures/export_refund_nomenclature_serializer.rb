module Api
  module V1
    module Measures
      class ExportRefundNomenclatureSerializer
        include FastJsonapi::ObjectSerializer
        set_id :export_refund_nomenclature_sid
        set_type :export_refund_nomenclature
        attributes :code, :description
      end
    end
  end
end