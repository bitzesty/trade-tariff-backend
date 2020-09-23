module TariffSynchronizer
  class CdsUpdateDownloader

    class AuthorisationError < StandardError; end

    delegate :instrument, :subscribe, to: ActiveSupport::Notifications

    attr_reader :date

    def initialize(date)
      @date = date
    end

    def perform
      return if check_date_already_downloaded?

      log_request_to_cds_daily_updates

      daily_files = JSON.parse(response.body)
      # Example:
      # { "filename"=>"tariff_dailyExtract_v1_20191009T235959.gzip",
      #   "downloadURL"=>"https://sdes.hmrc.gov.uk/api-download/156ec583-9245-484a-9f91-3919493a047d",
      #   "fileSize"=>478 }
      daily_files.select! { |file| file['filename'][23..30] == date.strftime("%Y%m%d") }

      if daily_files.empty?
        create_record_for_not_found_response
        return
      end

      daily_files.each do |file|
        TariffDownloader.new(file['filename'], file['downloadURL'], date, TariffSynchronizer::CdsUpdate).perform
      end
    end

    private

    def response
      @response ||= begin
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

    def check_date_already_downloaded?
      CdsUpdate.find(issue_date: date).present?
    end

    def missing_filename
      "#{date}_cds"
    end

    def update_or_create(state, file_name)
      TariffSynchronizer::CdsUpdate.find_or_create(filename: file_name, issue_date: date).update(state: state)
    end

    def log_request_to_cds_daily_updates
      instrument("get_cds_daily_updates.tariff_synchronizer", date: date)
    end

    def create_record_for_not_found_response
      # Do not create missing record until we are sure until the next day
      return if date >= Date.current

      update_or_create(BaseUpdate::MISSING_STATE, missing_filename)
      instrument("cds_not_found.tariff_synchronizer", date: date)
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
