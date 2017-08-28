module Api
  class ApiController < ApplicationController
    include GDS::SSO::ControllerMethods

    respond_to :json

    skip_before_action :verify_authenticity_token

    rescue_from Sequel::NoMatchingRow, Sequel::RecordNotFound do |exception|
      render json: { error: 'not found', url: request.url }, status: 404
    end

    protected

    def current_page
      Integer(params[:page] || 1)
    end

    def per_page
      20
    end
    helper_method :current_page, :per_page
  end
end
