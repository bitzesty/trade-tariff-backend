require 'tariff_synchronizer/response'

module TariffSynchronizer
  module FileService
    extend ActiveSupport::Concern

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
          crawler = Curl::Easy.new(url)
          crawler.ssl_verify_peer = false
          crawler.ssl_verify_host = false
          crawler.http_auth_types = :basic
          crawler.username = TariffSynchronizer.username
          crawler.password = TariffSynchronizer.password
          crawler.perform
        rescue Curl::Err::HostResolutionError => exception
          # NOTE could be a glitch in curb because it throws HostResolutionError
          # occasionally without any reason.
          send_request(url)
        end

        return Response.new(url, crawler.response_code, crawler.body_str)
      end
    end
  end
end
