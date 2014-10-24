class HomeController < ApplicationController
  respond_to :json

  def show
    render nothing: true
  end

  def not_found
    render_not_found
  end
end
