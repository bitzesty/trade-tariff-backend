#
# Script checks all actual and declarable commodities
# in databases and detects which commodities do not return 200 (eg: causing redirect)
#
# Use: script = UsefullCheckers::CheckCommodityCodes.new("https://www.trade-tariff.service.gov.uk")
#      script.run
#

module UsefullCheckers
  class CheckCommodityCodes

    attr_accessor :total_number_of_commodities,
                  :limit,
                  :host

    def initialize(host)
      @host = host
      @total_number_of_commodities = Commodity.actual
                                              .declarable
                                              .count
      @limit = 250
    end

    def run
      log_it("TOTAL: #{total_number_of_commodities}", "SCRIPT STARTED")

      queue_number = 1
      offset = 0

      while (queue_number * limit) <= total_number_of_commodities do
        log_it("QUEUE #{queue_number} #{offset} - #{offset + 250}", "STARTED")

        commodities = Commodity.actual
                               .declarable
                               .limit(limit, offset)

        commodities.map do |commodity|
          commodity_code = commodity.goods_nomenclature_item_id
          response = RestClient.get '#{host}/trade-tariff/commodities/#{commodity_code}.json'

          if response.code == 200
            log_it(commodity_code, "OK")
          else
            log_it(commodity_code, "NOT FOUND")
          end

          CommodityCheck.insert(
            commodity_code: commodity_code,
            goods_nomenclature_sid: commodity.goods_nomenclature_sid,
            producline_suffix: commodity.producline_suffix,
            status: response.code.to_s
          )

          sleep 1
        end

        offset += limit
        queue_number += 1
        sleep 3
      end

      log_it("TOTAL: #{total_number_of_commodities}", "SCRIPT FINISHED")
    end

    private

      def log_it(commodity_code, status)
        p ""
        p "-" * 100
        p "[#{commodity_code}] #{status}"
        p "-" * 100
        p ""
      end
  end
end
