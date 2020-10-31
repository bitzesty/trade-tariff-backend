module Api
  module Admin
    class ChemicalsController < ApiController
      before_action :authenticate_user!
      before_action :fetch_chemical, only: %i[show show_map]
      before_action :fetch_objects, only: %i[create_map update_map]

      # GET    /admin/chemicals
      def index
        @errors = []

        respond_with Chemical.all
      end

      # GET   /admin/chemicals/:chemical_id
      def show
        render_not_found and return unless @chemical.present?

        respond_with @chemical
      end

      # GET   /admin/chemicals/:chemical_id/map
      def show_map
        show
      end

      # POST  /admin/chemicals/:chemical_id/map/:gn_id
      def create_map
        if @map.present?
          @errors << "Mapping already exists: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
          respond_with(@chemical.refresh) and return
        end

        if @chemical.present? && @commodity.present?
          create_chemical_commodity_mapping
          fetch_map
          unless @map.present?
            @errors << "Newly created mapping was not found: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
          end
        else
          @errors << "Target commodity and/or chemical missing: chemical.id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.goods_nomenclature_item_id}"
        end

        respond_with @chemical.refresh
      end

      # PATCH /admin/chemicals/:chemical_id/map/:gn_id
      # PUT   /admin/chemicals/:chemical_id/map/:gn_id
      def update_map
        if @chemical.present? && @map.present? && @new_commodity.present?
          update_chemical_commodity_mapping
        else
          @errors << "Mapping was not updated: chemical.id: #{@chemical.id}, old_gn: #{@map.goods_nomenclature_item_id}, new_gn: #{@new_commodity.goods_nomenclature_item_id}"
        end

        respond_with @chemical.refresh
      end

      private

      def chemical_params
        # params.require(:data).permit(:type, attributes: [:title])
        params.require(:data).permit!
      end

      def fetch_chemical
        @errors = []

        unless id = params[:chemical_id] || params[:id] || false
          @errors << "Chemical id not found: chemical_id: #{params[:chemical_id]}"
        end

        @errors << "Chemical not found: chemical_id: #{params[:chemical_id]}" unless @chemical = Chemical.find(id: id)
      end

      def fetch_objects
        fetch_chemical
        @commodity = GoodsNomenclature.where(goods_nomenclature_sid: params[:gn_id]).first
        fetch_map
        @new_commodity = GoodsNomenclature.where(goods_nomenclature_sid: params[:new_id]).first if params[:new_id]
      end

      def fetch_map
        @map = ChemicalsGoodsNomenclatures.find(
          chemical_id: @chemical.id,
          goods_nomenclature_sid: @commodity.id
        )
      end

      def respond_with(obj, errors = @errors)
        if errors.any?
          data = { errors: [] }
          data[:errors] = errors.map do |error|
            { title: error }
          end
          render json: data, status: :unprocessable_entity
        else
          render json: Api::Admin::Chemicals::ChemicalSerializer.new(obj || @chemical.refresh).serializable_hash
        end
      end

      def create_chemical_commodity_mapping
        ChemicalsGoodsNomenclatures.insert(
          chemical_id: @chemical.id,
          goods_nomenclature_sid: @commodity.id
        )
      rescue StandardError
        @errors << "Mapping was not created: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
      end

      def update_chemical_commodity_mapping
        Sequel::Model.db.transaction do
          ChemicalsGoodsNomenclatures.unrestrict_primary_key
          ChemicalsGoodsNomenclatures.create(
            chemical_id: @chemical.id,
            goods_nomenclature_sid: @new_commodity.id
          )
          @map.destroy
        rescue StandardError
          @errors << "Mapping already exists: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
        end
      end
    end
  end
end
