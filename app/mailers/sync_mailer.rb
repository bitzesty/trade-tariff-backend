class SyncMailer < ActionMailer::Base
  default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>"

  def admin_notification(admin_email, failed_file_path, exception)
    @exception = exception
    @failed_file_path = failed_file_path

    mail to: admin_email, subject: "Failed Trade Tariff update"
  end
end
