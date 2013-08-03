module MailerEnvironment
  def subject_prefix(level = "info")
    "[#{Date.today}][#{TradeTariffBackend.deployed_environment}][#{level}]"
  end
end
