require 'goods_nomenclature_mapper'

module Api
  module V2
    class HeadingsController < ApiController
      before_action :find_heading, only: [:show, :changes]

      def show
        heading_cache_key = "heading-#{@heading.goods_nomenclature_sid}-#{actual_date}-#{TradeTariffBackend.currency}-#{@heading.declarable?}"
        if @heading.declarable?
          @measures = MeasurePresenter.new(@heading.measures_dataset.eager({geographical_area: [:geographical_area_descriptions,
                                                                                                { contained_geographical_areas: :geographical_area_descriptions }]},
                                                      {footnotes: :footnote_descriptions},
                                                      {measure_type: :measure_type_description},
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
                                                                                                            :measurement_unit_qualifier]}
                                                                            ]},
                                                      {quota_order_number: :quota_definition},
                                                      {excluded_geographical_areas: :geographical_area_descriptions},
                                                      :additional_code,
                                                      :full_temporary_stop_regulations,
                                                      :measure_partial_temporary_stops).all, @heading).validate!
          presenter = Api::V2::Headings::DeclarableHeadingPresenter.new(@heading, @measures, heading_cache_key)
          options = {}
          options[:include] = [:section, :chapter, 'chapter.guides', :footnotes,
                               :import_measures, 'import_measures.duty_expression', 'import_measures.measure_type',
                               'import_measures.legal_acts', 'import_measures.suspending_regulation',
                               'import_measures.measure_conditions', 'import_measures.geographical_area',
                               'import_measures.geographical_area.contained_geographical_areas',
                               'import_measures.excluded_geographical_areas',
                               'import_measures.footnotes', 'import_measures.additional_code',
                               'import_measures.export_refund_nomenclature',
                               'import_measures.order_number', 'import_measures.order_number.definition',
                               :export_measures, 'export_measures.duty_expression', 'export_measures.measure_type',
                               'export_measures.legal_acts', 'export_measures.suspending_regulation',
                               'export_measures.measure_conditions', 'export_measures.geographical_area',
                               'export_measures.geographical_area.contained_geographical_areas',
                               'export_measures.excluded_geographical_areas',
                               'export_measures.footnotes', 'export_measures.additional_code',
                               'export_measures.export_refund_nomenclature',
                               'export_measures.order_number', 'export_measures.order_number.definition',]
          render json: Api::V2::Headings::DeclarableHeadingSerializer.new(presenter, options).serializable_hash
        else
          @commodities = GoodsNomenclatureMapper.new(@heading.commodities_dataset.eager(:goods_nomenclature_indents,
                                                                                        :goods_nomenclature_descriptions)
                                                             .all).all
          presenter = Api::V2::Headings::HeadingPresenter.new(@heading, @commodities, heading_cache_key)
          options = {}
          options[:include] = [:section, :chapter, 'chapter.guides', :footnotes,
                               :commodities, 'commodities.overview_measures_indexed',
                               'commodities.overview_measures_indexed.duty_expression', 'commodities.overview_measures_indexed.measure_type']
          render json: Api::V2::Headings::HeadingSerializer.new(presenter, options).serializable_hash
        end
      end

      def changes
        key = "heading-#{@heading.goods_nomenclature_sid}-#{actual_date}-#{TradeTariffBackend.currency}/changes"
        @changes = Rails.cache.fetch(key, expires_at: actual_date.end_of_day) do
          ChangeLog.new(@heading.changes.where { |o|
            o.operation_date <= actual_date
          })
        end

        options = {}
        options[:include] = [:record, 'record.geographical_area', 'record.measure_type']
        render json: Api::V2::Changes::ChangeSerializer.new(@changes.changes, options).serializable_hash
      end

      private

      def find_heading
        @heading = Heading.actual
                          .non_grouping
                          .where(goods_nomenclatures__goods_nomenclature_item_id: heading_id)
                          .take

        raise Sequel::RecordNotFound if @heading.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end

      def heading_id
        "#{params[:id]}000000"
      end
    end
  end
end
