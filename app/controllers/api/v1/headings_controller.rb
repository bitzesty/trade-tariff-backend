require 'goods_nomenclature_mapper'

module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.actual
                          .non_grouping
                          .where(goods_nomenclatures__goods_nomenclature_item_id: heading_id)
                          .take

        if @heading.declarable?
          @measures = @heading.measures_dataset.eager({geographical_area: [:geographical_area_description, :children_geographical_areas]},
                                                        {footnotes: :footnote_description},
                                                        {measure_type: :measure_type_description},
                                                        {measure_components: [:duty_expression,
                                                                              {measurement_unit: :measurement_unit_description},
                                                                              :monetary_unit,
                                                                              :measurement_unit_qualifier]},
                                                        {measure_conditions: [{measure_action: :measure_action_description},
                                                                              {certificate: :certificate_description},
                                                                              :measurement_unit,
                                                                              :monetary_unit,
                                                                              :measurement_unit_qualifier,
                                                                              :measure_condition_code,
                                                                              :measure_condition_components]},
                                                        :quota_order_number,
                                                        {excluded_geographical_areas: :geographical_area_description},
                                                        :additional_code).all
        else
          @commodities = GoodsNomenclatureMapper.new(@heading.commodities_dataset.eager(:goods_nomenclature_indent,
                                                                                        :goods_nomenclature_description).all).root_entries
        end

        respond_with @heading
      end

      def heading_id
        "#{params[:id]}000000"
      end
    end
  end
end
