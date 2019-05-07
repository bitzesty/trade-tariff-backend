require 'mailer_environment'

class RunChapterPdfWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform
    batch = Sidekiq::Batch.new
    batch.description = "Produces PDFs for all chapters"
    chapter_ids = Section.all.map(&:chapters).flatten.map(&:goods_nomenclature_sid)
    # chapter_ids = %w(47137 32338 54748) # <- short chapters
    unless chapter_ids.empty?
      batch.on(:success, BatchCallback, bid: batch.bid, total: chapter_ids.size, start_time: Time.now.to_i)
      batch.jobs do
        chapter_ids.shuffle.each do |sid|
          GenerateChapterPdfWorker.perform_async(sid)
        end
      end
    else
      puts "Cancelled batch #{batch.bid}. No chapters were specified."
    end
  end

  class BatchCallback
    def on_complete(status, options)
      subject = "One or more PDF chapters were not created"
      message = "One or more PDF chapters were not created: #{status.failures}"
      email_results(subject, message, options)
      puts "Batch has #{status.failures} failures" if status.failures != 0
    end

    def on_success(status, options)
      elapsed_time = Time.now.to_i - options['start_time']
      subject = "All Trade Tariff PDF chapters were created"
      message = "PDF chapters created: #{options['total']} in #{elapsed_time} seconds."
      email_results(subject, message, options)
      puts "Batch #{options['bid']} succeeded in #{elapsed_time} seconds."

      RunPdfCombinerWorker.perform_async
    end

    def email_results(subject, message, options)
      Mailer.pdf_generation_report(subject, message, options).deliver_now
    end
  end

  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: TradeTariffBackend.from_email,
              to: TradeTariffBackend.admin_email

    def pdf_generation_report(subject, message, options)
      @options = options
      @message = message
      mail subject: subject
    end
  end
end
