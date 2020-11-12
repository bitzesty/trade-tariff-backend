module Api
  module Admin
    class ChemicalsController < ApiController
      before_action :authenticate_user!
      before_action :set_up_errors
      before_action :fetch_chemical, only: %i[show show_map update]
      before_action :fetch_objects, only: %i[create_map update_map delete_map]

      # GET    /admin/chemicals
      def index
        respond_with Chemical.order_by(:id).all
      end

      # GET   /admin/chemicals/:chemical_id
      def show
        render_not_found and return unless @chemical.present?

        respond_with @chemical
      end

      # POST   /admin/chemicals
      def create
        status = :created

        # params = {:chemical=>{:cas=>"0-1-0", :name=>"ethynylcyclopropane"}}
        chemical = Chemical.new do |c|
          c.cas = params[:cas]
        end

        Sequel::Model.db.transaction do
          chemical.save raise_on_failure: false
          begin
            chemical_name = chemical.reload.add_chemical_name name: params[:name]
          rescue Sequel::ValidationFailed
            @errors << chemical_name.stringify_sequel_errors
            status = :unprocessable_entity
          end
        end

        respond_with chemical.refresh, status: status
      end

      # PATCH   /admin/chemicals
      # PUT     /admin/chemicals
      def update
        status = :accepted
        unless params[:cas].present? || params[:chemical_name_id].present?
          @errors << "Missing paramter, one is required: cas: #{@chemical&.cas}, chemical_name_id: #{params[:chemical_name_id]}"
          status = :bad_request  
        end

        Sequel::Model.db.transaction do
          begin
            if params[:cas].present?
              @chemical.update(cas: params[:cas])
            end

            if params[:chemical_name_id].present?
              chemical_name = ChemicalName.where(id: params[:chemical_name_id], chemical_id: @chemical.id).take
              begin
                chemical_name.update(name: params[:new_chemical_name])
              rescue Sequel::ValidationFailed
                @errors << chemical_name.stringify_sequel_errors
                status = :unprocessable_entity
              end
            end
          rescue
            @errors << "Chemical was not updated: chemical.id: #{@chemical&.id}, cas: #{@chemical&.cas}, chemical_name_id: #{params[:chemical_name_id]}, new_chemical_name: #{params[:new_chemical_name]}"
            status = :not_found
          end
        end

        respond_with @chemical.refresh, status: status
      end

      # GET   /admin/chemicals/:chemical_id/map
      def show_map
        show
      end

      # POST  /admin/chemicals/:chemical_id/map/:gn_sid
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

      # PATCH /admin/chemicals/:chemical_id/map/:gn_sid
      # PUT   /admin/chemicals/:chemical_id/map/:gn_sid
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

      # DELETE /admin/chemicals/:chemical_id/map/:gn_sid
      def delete_map
        respond_with(@chemical.refresh, status: :not_found) and return if @map.nil?

        status = @map.destroy ? :ok : :not_found

        respond_with @chemical.refresh, status: status
      end

      private

      def fetch_chemical
        unless id = params[:chemical_id] || params[:id] || false
          @errors << "Chemical id not found: chemical_id: #{id}"
        end

        @chemical = Chemical.where(id: id).take
      end

      def fetch_objects
        fetch_chemical
        fetch_commodity
        fetch_map
        fetch_new_commodity
      end
      
      def fetch_map
        @map = @commodity.nil? ? nil : ChemicalsGoodsNomenclatures.find(
          chemical_id: @chemical.id,
          goods_nomenclature_sid: @commodity.id
        ) unless @errors.any?
      end
      
      def fetch_commodity
        @commodity = case
        when params[:gn_iid]
          fetch_commodity_by_iid 
        when params[:gn_sid]
          fetch_commodity_by_sid
        else
          nil
        end
      end

      def fetch_commodity_by_iid(iid = params[:gn_iid])
        Commodity.find_commodity_by_code iid
      end

      def fetch_commodity_by_sid(sid = params[:gn_sid])
        Commodity.where(goods_nomenclature_sid: sid).take
      end

      def fetch_new_commodity
        @new_commodity = GoodsNomenclature.where(goods_nomenclature_item_id: params[:new_id]).take if params[:new_id]
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
          status = status || :unprocessable_entity
        else
          data = Api::Admin::Chemicals::ChemicalSerializer.new(obj || @chemical.refresh).serializable_hash
          status = status || :ok
        end

        render json: data, status: status
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

      def update_chemical_name
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
