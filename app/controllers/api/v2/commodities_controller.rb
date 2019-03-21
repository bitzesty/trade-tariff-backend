module Api
  module V1
    class CommoditiesController < ApiController
      before_action :find_commodity, only: [:show, :changes]

      def show
        @measures = MeasurePresenter.new(
          @commodity.measures_dataset.eager(
            { footnotes: :footnote_descriptions },
            { measure_type: :measure_type_description },
            { measure_components: [{ duty_expression: :duty_expression_description },
                                   { measurement_unit: :measurement_unit_description },
                                   :monetary_unit,
                                   :measurement_unit_qualifier] },
            { measure_conditions: [{ measure_action: :measure_action_description},
                                   { certificate: :certificate_descriptions },
                                   { certificate_type: :certificate_type_description },
                                   { measurement_unit: :measurement_unit_description },
                                   :monetary_unit,
                                   :measurement_unit_qualifier,
                                   { measure_condition_code: :measure_condition_code_description },
                                   { measure_condition_components: [:measure_condition,
                                                                    :duty_expression,
                                                                    :measurement_unit,
                                                                    :monetary_unit,
                                                                    :measurement_unit_qualifier]
                                   }]
            },
            { quota_order_number: :quota_definition },
            { excluded_geographical_areas: :geographical_area_descriptions },
            { geographical_area: :geographical_area_descriptions },
            :additional_code,
            :full_temporary_stop_regulations,
            :measure_partial_temporary_stops
          ).all, @commodity
        ).validate!

        @geographical_areas = GeographicalArea.actual.where("geographical_area_sid IN ?", @measures.map(&:geographical_area_sid)).
            eager(:geographical_area_descriptions, { contained_geographical_areas: :geographical_area_descriptions }).all

        @commodity_cache_key = "commodity-#{@commodity.goods_nomenclature_sid}-#{actual_date}-#{TradeTariffBackend.currency}"

        presenter = Api::V1::Commodities::CommodityPresenter.new(@commodity, @measures, @geographical_areas, @commodity_cache_key)
        options = {}
        options[:include] = [:section, :chapter, 'chapter.guides', :heading, :ancestors, :footnotes,
                             :import_measures, 'import_measures.duty_expression', 'import_measures.measure_type',
                             'import_measures.legal_acts', 'import_measures.suspending_regulation',
                             'import_measures.measure_conditions', 'import_measures.geographical_area',
                             'import_measures.geographical_area.children_geographical_areas',
                             'import_measures.excluded_geographical_areas',
                             'import_measures.footnotes', 'import_measures.additional_code',
                             'import_measures.export_refund_nomenclature',
                             'import_measures.order_number', 'import_measures.order_number.definition',
                             :export_measures, 'export_measures.duty_expression', 'export_measures.measure_type',
                             'export_measures.legal_acts', 'export_measures.suspending_regulation',
                             'export_measures.measure_conditions', 'export_measures.geographical_area',
                             'export_measures.geographical_area.children_geographical_areas',
                             'export_measures.excluded_geographical_areas',
                             'export_measures.footnotes', 'export_measures.additional_code',
                             'export_measures.export_refund_nomenclature',
                             'export_measures.order_number', 'export_measures.order_number.definition',]
        render json: Api::V1::Commodities::CommoditySerializer.new(presenter, options).serializable_hash
        # respond_with @commodity
      end

      def changes
        key = "commodity-#{@commodity.goods_nomenclature_sid}-#{actual_date}-#{TradeTariffBackend.currency}/changes"
        @changes = Rails.cache.fetch(key, expires_at: actual_date.end_of_day) do
          ChangeLog.new(@commodity.changes.where { |o|
            o.operation_date <= actual_date
          })
        end

        render 'api/v1/changes/changes'
      end

      private

      def find_commodity
        @commodity = Commodity.actual
                              .declarable
                              .by_code(params[:id])
                              .take

        raise Sequel::RecordNotFound if @commodity.children.any?
        raise Sequel::RecordNotFound if @commodity.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end
    end
  end
end
