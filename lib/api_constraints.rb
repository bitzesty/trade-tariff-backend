class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    # API versioning isn't something that we've made a decision on yet, so this might be subject
    # to change.
    # Currently the only client of the API is TradeTariffWebApp and we are free to evolve both the
    # server and the client in lockstep.
    @default || req.headers['Accept'].include?("application/vnd.uktt.v#{@version}")
  end
end
