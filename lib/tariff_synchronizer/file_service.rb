module TariffSynchronizer
  module FileService
    extend self

    mattr_accessor :terminating_http_codes
    self.terminating_http_codes = [200, 404]

    def write_file(path, body)
      begin
        File.open(path, "wb") {|f|
          if f.write(body) > 0
            TariffSynchronizer.logger.info "Update file written to: #{File.join(Rails.root, path)}"
          end
        }
      rescue Exception => e
        TariffSynchronizer.logger.error "Could not write: #{path}. Error: #{e}."
      end
    end

    def get_content(url)
      # The server in question may respond with 403 from time to time so keep retrying
      # until it returns either 200 or 404
      loop do
        response_code, body = send_request(url)

        if response_code == 200
          return body
        end

        sleep TariffSynchronizer.request_throttle
        break if is_terminating_code?(response_code)
      end
    end

    private

    def send_request(url)
      begin
        crawler = Curl::Easy.new(url)
        crawler.ssl_verify_peer = false
        crawler.http_auth_types = :basic
        crawler.username = TariffSynchronizer.username
        crawler.password = TariffSynchronizer.password
        crawler.perform
      rescue Curl::Err::HostResolutionError => exception
        # NOTE could be a glitch in curb because it throws HostResolutionError
        # occasionally without any reason.
        send_request(url)
      end

      return crawler.response_code, crawler.body_str
    end

    def is_terminating_code?(code)
      terminating_http_codes.include? code
    end
  end
end
