module Api
  class ApiController < ApplicationController
    include GDS::SSO::ControllerMethods

    respond_to :json

    skip_before_filter :verify_authenticity_token

    rescue_from Sequel::NoMatchingRow, Sequel::RecordNotFound do |exception|
      render json: { error: 'not found', url: request.url }, status: 404
    end
  end
end
