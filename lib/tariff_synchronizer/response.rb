require 'addressable/uri'

module TariffSynchronizer
  class Response
    TERMINATING_RESPONSE_CODES = [200, 404]

    attr_reader :response_code, :url

    delegate :present?, :size, to: :content, prefix: true, allow_nil: true

    def initialize(url, response_code, content)
      @url = url
      @response_code = response_code
      @content = content
    end

    def ==(other_response)
      self.url == other_response.url &&
      self.response_code == other_response.response_code &&
      self.content == other_response.content
    end

    def uri
      @uri ||= Addressable::URI.parse(url)
    end

    def file_name
      uri.basename
    end

    def success?
      response_code == 200
    end

    def not_found?
      response_code == 404
    end

    def content
      @content.presence || ""
    end

    def valid?
      true
    end

    def terminated?
      response_code.in? TERMINATING_RESPONSE_CODES
    end

    def retry_count_exceeded!
      @retry_count_exceeded = true
    end

    def retry_count_exceeded?
      @retry_count_exceeded
    end
  end
end
