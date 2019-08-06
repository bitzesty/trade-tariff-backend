module Api
  module V2
    class FootnotesController < ApiController
      before_action :find_footnotes

      def search
        # raise Sequel::RecordNotFound if @footnotes.empty?

        options = {}
        options[:include] = [:measures, 'measures.goods_nomenclature']
        render json: Api::V2::Footnotes::FootnoteSerializer.new(@footnotes, options).serializable_hash
      end

      private

      def find_footnotes
        raise Sequel::RecordNotFound unless params[:code] || params[:description]

        TimeMachine.now do
          @footnotes = FootnoteSearchService.new(params).perform
        end
      end
    end
  end
end
