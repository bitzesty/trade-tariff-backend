module Api
  module Admin
    class ChemicalsController < ApiController
      before_action :authenticate_user!
      before_action :set_up_errors
      before_action :fetch_chemical, only: %i[show show_map update names delete_map create_map update_map]

      # GET    /admin/chemicals
      def index
        @chemicals = Chemical.eager(:chemical_names, :goods_nomenclatures).order_by(:id).paginate(page, per_page).all

        respond_with @chemicals, meta: serialization_meta
      end

      # GET   /admin/chemicals/:chemical_id
      def show
        render_not_found and return unless @chemical.present?

        respond_with @chemical
      end

      # POST   /admin/chemicals
      def create
        status = :created

        # params = {"data"=>{"attributes"=>{"cas"=>"9-99-9", "name"=>"Kyber (crystaline form)"}, "type"=>"chemicals"}}
        chemical_params = params['data']['attributes']

        chemical = Chemical.new do |c|
          c.cas = chemical_params['cas']
        end

        Sequel::Model.db.transaction do
          chemical.save raise_on_failure: false
          begin
            chemical_name = chemical.reload.add_chemical_name name: chemical_params['name']
          rescue Sequel::ValidationFailed
            @errors << chemical_name.stringify_sequel_errors
            status = :unprocessable_entity
          end
        end

        respond_with chemical, status: status
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
        rescue StandardError
          @errors << "Chemical was not updated: chemical.id: #{@chemical&.id}, cas: #{@chemical&.cas}, chemical_name_id: #{params[:chemical_name_id]}, new_chemical_name: #{params[:new_chemical_name]}"
          status = :not_found
        end

        respond_with @chemical.refresh, status: status
      end

      # GET   /admin/chemicals/:chemical_id/map
      def show_map
        show
      end

      # POST  /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      def create_map
        @commodity = fetch_commodity_by_iid
        existing_map = ChemicalsGoodsNomenclatures.find(
          chemical_id: @chemical.id,
          goods_nomenclature_sid: @commodity.id
        )
        if existing_map.present?
          @errors << "Mapping already exists: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
          respond_with(@chemical.refresh, status: :conflict) and return
        end

        status = :not_found
        if @chemical.present? && @commodity.present?
          status = create_chemical_commodity_mapping
          fetch_map
          unless @map.present?
            @errors << "Newly created mapping was not found: chemical_id: #{@chemical&.id}, goods_nomenclature_sid: #{@commodity&.id}"
            status = :internal_server_error
          end
        else
          @errors << "Target commodity and/or chemical missing: chemical.id: #{@chemical&.id}, goods_nomenclature_sid: #{@commodity&.id}"
        end

        respond_with @chemical.refresh, status: status
      end

      # PATCH /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      # PUT   /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      def update_map
        fetch_commodity
        fetch_map
        fetch_new_commodity

        status = :not_found
        if @chemical.present? && @map.present? && @new_commodity.present?
          status = update_chemical_commodity_mapping
        else
          @errors << "Mapping was not updated: chemical.id: #{@chemical&.id}, old_gn: #{@map&.goods_nomenclature_sid}, new_gn: #{@new_commodity&.goods_nomenclature_item_id}"
        end

        respond_with @chemical.refresh, status: status
      end

      # DELETE /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      def delete_map
        fetch_commodity
        fetch_map

        respond_with(@chemical.refresh, status: :not_found) and return if @map.nil?

        status = @map.destroy ? :ok : :not_found

        respond_with @chemical.refresh, status: status
      end

      def name
        chemical_name = ChemicalName.find(id: params[:chemical_name_id], chemical_id: params[:chemical_id])
        data = Api::Admin::Chemicals::ChemicalNameSerializer.new chemical_name
        status = :ok

        render json: data, status: status
      end

      def names
        data = Api::Admin::Chemicals::ChemicalNameSerializer.new @chemical.chemical_names
        status = :ok

        render json: data, status: status
      end

      private

      def fetch_chemical
        unless id = params[:chemical_id] || params[:id] || false
          @errors << "Chemical id not found: chemical_id: #{id}"
        end

        @chemical = Chemical.where(id: id).take
      end

      def fetch_map
        unless @errors.any?
          @map = if @commodity.present?
                   ChemicalsGoodsNomenclatures.find(
                     chemical_id: @chemical.id,
                     goods_nomenclature_sid: @commodity.id
                   )
                 end
        end
      end

      def fetch_commodity
        @commodity = fetch_commodity_by_sid
      end

      def fetch_commodity_by_iid(iid = params[:goods_nomenclature_item_id])
        GoodsNomenclature.where(goods_nomenclature_item_id: iid).take
      end

      def fetch_commodity_by_sid(sid = params[:goods_nomenclature_sid])
        GoodsNomenclature.where(goods_nomenclature_sid: sid).take
      end

      def fetch_new_commodity
        @new_commodity = fetch_commodity_by_iid
      end

      def set_up_errors
        @errors ||= []
      end

      def respond_with(obj, status: :ok, errors: @errors, meta: {})
        if errors.any?
          data = { errors: [] }
          data[:errors] = errors.map do |error|
            { title: error }
          end
          status ||= :unprocessable_entity
        else
          data = Api::Admin::Chemicals::ChemicalSerializer.new((obj || @chemical.refresh), meta).serializable_hash
          status ||= :ok
        end

        render json: data, status: status
      end

      def create_chemical_commodity_mapping
        status = :unprocessable_entity
        begin
          ChemicalsGoodsNomenclatures.insert(
            chemical_id: @chemical.id,
            goods_nomenclature_sid: @commodity.id
          )
          status = :created
        rescue StandardError
          @errors << "Mapping was not created: chemical_id: #{@chemical.id}, goods_nomenclature_sid: #{@commodity.id}"
        end
        status
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

      def per_page
        params.fetch(:per_page, 200).to_i
      end

      def page
        params.fetch(:page, 1).to_i
      end

      def chemicals_count
        Chemical.all.count || 0
      end

      def serialization_meta
        {
          meta: {
            pagination: {
              page: page,
              per_page: per_page,
              total_count: chemicals_count
            }
          }
        }
      end
    end
  end
end
