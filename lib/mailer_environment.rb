module MailerEnvironment
  def subject_prefix(level = "info")
    "[#{Date.today}][#{TradeTariffBackend.platform}][#{level}]"
  end
end
