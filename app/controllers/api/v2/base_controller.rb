module Api
  module V2
    class BaseController < ApiController
      before_action :set_jsonapi_content_type

      def json_content_type
        'application/vnd.api+json'
      end

      def set_jsonapi_content_type
        response.headers['Content-Type'] = json_content_type if request.format == :json
      end
    end
  end
end
