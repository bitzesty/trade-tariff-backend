module Api
  module Admin
    class ChemicalsController < ApiController
      before_action :authenticate_user!
      before_action :set_up_errors
      before_action :fetch_chemical, only: %i[show show_map]
      before_action :fetch_objects, only: %i[create_map update_map]

      # GET    /admin/chemicals
      def index
        respond_with Chemical.order_by(:id).all
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
          respond_with(@chemical.refresh, status: :conflict) and return
        end

        status = :created
        if @chemical.present? && @commodity.present?
          create_chemical_commodity_mapping
          fetch_map
          unless @map.present?
            @errors << "Newly created mapping was not found: chemical_id: #{@chemical&.id}, goods_nomenclature_sid: #{@commodity&.id}"
            status = :internal_server_error
          end
        else
          @errors << "Target commodity and/or chemical missing: chemical.id: #{@chemical&.id}, goods_nomenclature_sid: #{@commodity&.id}"
          status = :not_found
        end

        respond_with @chemical.refresh, status: status
      end

      # PATCH /admin/chemicals/:chemical_id/map/:gn_id
      # PUT   /admin/chemicals/:chemical_id/map/:gn_id
      def update_map
        status = :accepted
        if @chemical.present? && @map.present? && @new_commodity.present?
          status = update_chemical_commodity_mapping
        else
          @errors << "Mapping was not updated: chemical.id: #{@chemical&.id}, old_gn: #{@map&.goods_nomenclature_sid}, new_gn: #{@new_commodity&.goods_nomenclature_item_id}"
          status = :not_found
        end

        respond_with @chemical.refresh, status: status
      end

      private

      def fetch_chemical
        unless id = params[:chemical_id] || params[:id] || false
          @errors << "Chemical id not found: chemical_id: #{id}"
        end

        @errors << "Chemical not found: chemical_id: #{params[:chemical_id]}" unless @chemical = Chemical.find(id: id)
      end

      def fetch_objects
        fetch_chemical
        fetch_commodity
        fetch_map
        fetch_new_commodity
      end
      
      def fetch_map
        @map = ChemicalsGoodsNomenclatures.find(
          chemical_id: @chemical.id,
          goods_nomenclature_sid: @commodity.id
        ) unless @errors.any?
      end
      
      def fetch_commodity
        @commodity = begin
          GoodsNomenclature.where(goods_nomenclature_sid: params[:gn_id]).first
        rescue Sequel::DatabaseError#PG::NumericValueOutOfRange
          GoodsNomenclature.where(goods_nomenclature_item_id: params[:gn_id]).first
        end
        @errors << "Commodity not found: id: #{params[:gn_id]}" unless @commodity
      end

      def fetch_new_commodity
        @new_commodity = GoodsNomenclature.where(goods_nomenclature_item_id: params[:new_id]).first if params[:new_id]
      end

      def set_up_errors
        @errors ||= []
      end

      def respond_with(obj, status: :ok, errors: @errors)
        if errors.any?
          data = { errors: [] }
          data[:errors] = errors.map do |error|
            { title: error }
          end
          render json: data, status: :unprocessable_entity
        else
          render json: Api::Admin::Chemicals::ChemicalSerializer.new(obj || @chemical.refresh).serializable_hash, status: status
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
          status = :accepted
        rescue StandardError
          @errors << "Mapping already exists: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
          status = :conflict
        end
        status
      end
    end
  end
end
