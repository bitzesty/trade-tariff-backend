require 'combine_pdf'
require 'net/http'

class RunPdfCombinerWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform
    set_s3
    create_combined_pdf
    upload_to_s3
    verify_on_s3
    delete_from_ephemeral
    email_results
  end

  private

  def create_combined_pdf
    pdf = CombinePDF.new
    bucket = @s3.bucket(bucket_name)
    @chapters = bucket.objects({prefix: bucket_prefix}).collect(&:key)
    @chapters.each do |key|
      url = bucket.object(key).presigned_url(:get)
      pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(url)).body)
    end
    pdf.save ephemeral_file_path
  end

  def ephemeral_file_path
    File.join(Rails.root, "public", "pdf", "tariff", @key)
  end

  def s3_file_path
    File.join(@dir, @key).gsub(/^\//, '')
  end

  def bucket_name
    ENV.fetch("AWS_BUCKET_NAME")
  end

  def bucket_prefix
    File.join(@dir, "chapters").gsub(/^\//, '')
  end

  def set_s3
    @dir = ENV["AWS_PDF_ROOT_PATH"] || ''
    @key = ENV["AWS_PDF_FILENAME"] || 'tariff.pdf'
    @s3 = Aws::S3::Resource.new(
      region: ENV.fetch("AWS_REGION"),
      access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY")
    )
    @s3_obj = @s3.bucket(bucket_name).object(s3_file_path)
  end

  def upload_to_s3
    File.open(ephemeral_file_path, 'rb') do |pdf|
      @s3_obj.put(body: pdf)
    end
  end

  def verify_on_s3
    if @s3_obj.exists?
      logger.info "PDF saved on S3: #{s3_file_path}"
    else
      logger.info "File '#{s3_file_path}' is not in s3 bucket!"
    end
  end

  def delete_from_ephemeral
    File.delete(ephemeral_file_path) if File.exist?(ephemeral_file_path)
  end

  def email_results
    presigned_url = @s3_obj.presigned_url(:get)
    subject = "The Trade Tariff PDF was produced"
    message = "#{@chapters.size} chapters were combined into a single PDF. (#{presigned_url})"
    options = { key: s3_file_path, public_url: presigned_url }
    Mailer.pdf_generation_report(subject, message, options).deliver_now
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
