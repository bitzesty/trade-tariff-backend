module TariffSynchronizer
  class CdsUpdateDownloader

    class AuthorisationError < StandardError; end

    delegate :instrument, :subscribe, to: ActiveSupport::Notifications

    attr_reader :request_date

    def initialize(request_date)
      @request_date = request_date
    end

    def perform
      log_request_to_cds_daily_updates

      # CDS updates are published with a few days delay so we should check past dates.
      range = ((request_date - 5.days)..request_date).to_a
      daily_files = JSON.parse(response.body)

      return if daily_files.empty?

      range.each do |date|
        file = daily_files.find { |df| df['filename'][23..30] == date.strftime("%Y%m%d") }
        next unless file
        TariffDownloader.new(file['filename'], file['downloadURL'], date, TariffSynchronizer::CdsUpdate).perform
      end
    end

    private

    # Example:
    # { "filename"=>"tariff_dailyExtract_v1_20191009T235959.gzip",
    #   "downloadURL"=>"https://sdes.hmrc.gov.uk/api-download/156ec583-9245-484a-9f91-3919493a047d",
    #   "fileSize"=>478 }
    # downloadURL contains gzip file with an xml file inside.
    def response
      @response = Rails.cache.fetch('cds-updates-list', expires_in: 2.hours) do
        uri = URI::join(ENV['HMRC_API_HOST'], '/bulk-data-download/list/TARIFF-DAILY')
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        request["User-Agent"] = "Trade Tariff Backend"
        request["Accept"] = "application/vnd.hmrc.1.0+json"
        request["Authorization"] = "Bearer #{access_token}"
        https.request(request)
      end
    end

    def log_request_to_cds_daily_updates
      instrument("get_cds_daily_updates.tariff_synchronizer", date: request_date)
    end

    def access_token
      uri = URI::join(ENV['HMRC_API_HOST'], '/oauth/token')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(
        client_id: ENV['HMRC_CLIENT_ID'],
        client_secret: ENV['HMRC_CLIENT_SECRET'],
        grant_type: 'client_credentials'
      )

      response = https.request(request)

      if response.code == '200'
        JSON.parse(response.body)['access_token']
      else
        raise AuthorisationError.new(response.body)
      end
    end
  end
end
