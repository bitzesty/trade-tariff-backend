class HomeController < ApplicationController
  def show

  end
  def stats
    if params[:q_on].present?
      @q_on = DateTime.parse(params[:q_on]).to_date
    else
      @q_on = Date.today
    end
    # @metrics = SearchMetric.where(q_on: @q_on).desc(:count)
  end

  def not_found
    render_not_found
  end
end
