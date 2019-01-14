class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :json, :html

  before_action :configure_currency
  around_action :configure_time_machine

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                           with: :render_error
    rescue_from Sequel::RecordNotFound,              with: :render_not_found
    rescue_from ActionController::RoutingError,      with: :render_not_found
    rescue_from ActionController::UnknownController, with: :render_not_found
    rescue_from AbstractController::ActionNotFound,  with: :render_not_found
  end

  def render_not_found
    respond_to do |format|
      format.html {
        render html: "404 - Not Found", status: 404
      }
      format.json {
        render json: { error: "404 - Not Found" }, status: 404
      }
    end
  end

  def render_error(exception)
    logger.error exception
    logger.error exception.backtrace
    ::Raven.capture_exception(exception)

    respond_to do |format|
      format.html {
        render html: "500 - Internal Server Error: #{exception.message}", status: 500
      }
      format.json {
        render json: { error: "500 - Internal Server Error: #{exception.message}" }, status: 500
      }
    end
  end

  def nothing
    head :ok
  end

protected

  def append_info_to_payload(payload)
    super
    payload[:user_agent] = request.headers["HTTP_X_ORIGINAL_USER_AGENT"].presence || request.env["HTTP_USER_AGENT"]
  end

private

  def actual_date
    Date.parse(params[:as_of].to_s)
  rescue ArgumentError # empty as_of param means today
    Date.current
  end
  helper_method :actual_date

  def configure_time_machine
    TimeMachine.at(actual_date) do
      yield
    end
  end

  def configure_currency
    TradeTariffBackend.currency = params[:currency]&.to_s&.upcase
  end
end
