module Api
  module V2
    class ChemicalsController < ApiController
      def index
        @chemicals = Chemical.all
        # @chemicals = Chemical.limit(1000).to_a

        render json: Api::V2::Chemicals::ChemicalListSerializer.new(@chemicals).serializable_hash
      end

      def show
        @chemical = Chemical.where(cas: params[:id]).take
        options = {}
        options[:include] = %i[goods_nomenclatures chemical_names]
        render json: Api::V2::Chemicals::ChemicalSerializer.new(@chemical, options).serializable_hash
      end
    end
  end
end
