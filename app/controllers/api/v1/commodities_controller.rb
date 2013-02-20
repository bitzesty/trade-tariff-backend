module Api
  module V1
    class CommoditiesController < ApplicationController
      before_filter :find_commodity, only: [:show]

      def show
        @measures = MeasurePresenter.new(@commodity.measures_dataset.eager({geographical_area: [:geographical_area_descriptions,
                                                                                                { contained_geographical_areas: :geographical_area_descriptions }]},
                                                      {footnotes: :footnote_descriptions},
                                                      {type: :measure_type_description},
                                                      {measure_components: [{duty_expression: :duty_expression_description},
                                                                            {measurement_unit: :measurement_unit_description},
                                                                            :monetary_unit,
                                                                            :measurement_unit_qualifier]},
                                                      {measure_conditions: [{measure_action: :measure_action_description},
                                                                            {certificate: :certificate_descriptions},
                                                                            {certificate_type: :certificate_type_description},
                                                                            {measurement_unit: :measurement_unit_description},
                                                                            :monetary_unit,
                                                                            :measurement_unit_qualifier,
                                                                            {measure_condition_code: :measure_condition_code_description},
                                                                            {measure_condition_components: [:measure_condition,
                                                                                                            :duty_expression,
                                                                                                            :measurement_unit,
                                                                                                            :monetary_unit,
                                                                                                            :measurement_unit_qualifier]
                                                                            }]},
                                                      {quota_order_number: :quota_definition},
                                                      {excluded_geographical_areas: :geographical_area_descriptions},
                                                      :additional_code,
                                                      :full_temporary_stop_regulations,
                                                      :measure_partial_temporary_stops).all, @commodity).validate!

        respond_with @commodity
      end

      private

      def find_commodity
        @commodity = Commodity.actual
                              .declarable
                              .by_code(params[:id])
                              .take

        raise Sequel::RecordNotFound if @commodity.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end
    end
  end
end
