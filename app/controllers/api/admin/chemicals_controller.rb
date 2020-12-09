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

        chemical = Chemical.new do |c|
          c.cas = chemical_params['cas']
        end

        @errors, status = chemical.save_with_name chemical_params['name']
        respond_with chemical, status: status
      end

      # PATCH   /admin/chemicals
      # PUT     /admin/chemicals
      def update
        status = :accepted
        unless params[:cas].present? || params[:chemical_name_id].present?
          @errors << "Missing paramter, at least one is required: cas: #{@chemical&.cas}, chemical_name_id: #{params[:chemical_name_id]}"
          status = :bad_request
        else
          @errors, status = @chemical.update_cas_and_or_name(
            new_cas: params[:cas],
            chemical_name_id: params[:chemical_name_id],
            new_chemical_name: params[:new_chemical_name]
          )
        end

        respond_with @chemical.refresh, status: status
      end

      # GET   /admin/chemicals/:chemical_id/map
      def show_map
        show
      end

      # POST  /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      def create_map
        @errors, status = ChemicalsGoodsNomenclatures.create_map(commodity: fetch_commodity_by_iid, chemical: @chemical)

        respond_with @chemical.refresh, status: status
      end

      # PATCH /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      # PUT   /admin/chemicals/:chemical_id/map/:goods_nomenclature_sid
      def update_map
        fetch_commodity
        fetch_map
        fetch_new_commodity

        @errors, status = ChemicalsGoodsNomenclatures.update_map(chemical: @chemical, map: @map, commodity: @commodity, new_commodity: @new_commodity)
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
        data = Api::Admin::Chemicals::ChemicalNameSerializer.new(chemical_name(id: params[:chemical_name_id], chemical_id: params[:chemical_id]))
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

      def per_page
        params.fetch(:per_page, 200).to_i
      end

      def page
        params.fetch(:page, 1).to_i
      end

      def serialization_meta
        {
          meta: {
            pagination: {
              page: page,
              per_page: per_page,
              total_count: Chemical.all.count || 0
            }
          }
        }
      end

      def chemical_params
        params['data']['attributes']
      end

      def chemical_name(id:)
        ChemicalName.find(id: id)
      end
    end
  end
end
