module Api
  class ApiController < ApplicationController
    include GDS::SSO::ControllerMethods

    respond_to :json

    skip_before_filter :verify_authenticity_token
  end
end
