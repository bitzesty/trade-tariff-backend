module TariffSynchronizer
  module FileService
    extend self

    mattr_accessor :terminating_http_codes
    self.terminating_http_codes = [200, 404]

    def get_date(file_name)
      Date.parse(file_name.to_s.match(/(.*)_(.*)$/)[1]) if file_name.present?
    end

    def write_file(path, body)
      data_file = File.new(path, "w")
      data_file.write(body)
      data_file.close
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
      crawler = Curl::Easy.new(url)
      crawler.http_auth_types = :basic
      crawler.username = TariffSynchronizer.username
      crawler.password = TariffSynchronizer.password
      crawler.perform

      return crawler.response_code, crawler.body_str
    end

    def is_terminating_code?(code)
      terminating_http_codes.include? code
    end
  end
end
