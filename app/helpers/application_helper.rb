module ApplicationHelper
  # Used in generating links in JSON responses
  #
  # Trade Tariff Frontend app proxies API requests to the
  # backend. We need to prefix the link /trade-tariff (which
  # is an app slug of tariff) so that users would receive
  # correct links
  def api_link(relative_link)
    "/trade-tariff#{relative_link}"
  end
end
