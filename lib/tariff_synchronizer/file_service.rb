require 'tariff_synchronizer/response'

module TariffSynchronizer
  module FileService
    extend ActiveSupport::Concern

    class DownloadException < StandardError
      attr_reader :url, :original

      def initialize(url, original)
        super("TariffSynchronizer::FileService::DownloadException")

        @url = url
        @original = original
      end
    end

    module ClassMethods
      def write_file(path, body)
        begin
          File.open(path, "wb") {|f|
            f.write(body)
          }
        rescue Errno::ENOENT
          ActiveSupport::Notifications.instrument("cant_open_file.tariff_synchronizer", path: path)
        rescue IOError
          ActiveSupport::Notifications.instrument("cant_write_to_file.tariff_synchronizer", path: path)
        rescue Errno::EACCES
          ActiveSupport::Notifications.instrument("write_permission_error.tariff_synchronizer", path: path)
        ensure
          return false
        end
      end

      def download_content(url)
        # The server in question may respond with 403 from time to time so keep retrying
        # until it returns either 200 or 404 or retry count limit is reached
        retry_count = TariffSynchronizer.retry_count

        loop do
          response = send_request(url)

          if response.terminated?
            return response
          elsif retry_count == 0
            response.retry_count_exceeded!

            return response
          else
            retry_count -= 1
            ActiveSupport::Notifications.instrument("delay_download.tariff_synchronizer", url: url)
            sleep TariffSynchronizer.request_throttle
          end
        end
      end

      private

      def send_request(url)
        begin
          crawler = Faraday::Connection.new(url) do |crawler|
            crawler.adapter Faraday.default_adapter
            crawler.request :basic_auth,
                            TariffSynchronizer.username,
                            TariffSynchronizer.password
          end
          response = crawler.get
        rescue Faraday::Error::ClientError => exception
          raise DownloadException.new(url, exception)
        end

        Response.new(url, response.status, response.body)
      end
    end
  end
end
