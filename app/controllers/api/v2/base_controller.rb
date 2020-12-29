module Api
  module V2
    class BaseController < ApiController
      before_action :set_jsonapi_content_type

      def set_jsonapi_content_type
        response.headers['Content-Type'] = 'application/vnd.api+json'
      end
    end
  end
end
