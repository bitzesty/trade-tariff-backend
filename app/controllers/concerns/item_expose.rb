module Controllers
  module ItemExpose
    extend ActiveSupport::Concern

    def item
      @item ||= if params[:heading_id]
                  Heading.includes(:measures).find_by(short_code: params[:heading_id])
                elsif params[:commodity_id]
                  Commodity.includes(:measures).find_by(code: params[:commodity_id])
                end
    end
    private :item

  end
end
