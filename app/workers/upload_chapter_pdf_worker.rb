class UploadChapterPdfWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform(pdf_file_path)
    @dir, @key = File.split(pdf_file_path)
    set_s3_object
    upload_to_s3
    verify_on_s3
    delete_from_ephemeral
  end

  private

  def ephemeral_file_path
    File.join(@dir, @key)
  end

  def s3_file_path
    File.join(ENV.fetch("AWS_PDF_ROOT_PATH"), "chapters", @key).gsub(/^\//, '')
  end

  def bucket_name
    ENV.fetch("AWS_PDF_BUCKET_NAME")
  end

  def set_s3_object
    s3 = Aws::S3::Resource.new(
      region: ENV.fetch("AWS_PDF_REGION"),
      access_key_id: ENV.fetch("AWS_PDF_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_PDF_SECRET_ACCESS_KEY")
    )
    @s3_obj = s3.bucket(bucket_name).object(s3_file_path)
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
      logger.info "File '#{s3_file_path}' is not in S3 bucket!"
    end
  end

  def delete_from_ephemeral
    File.delete(ephemeral_file_path) if File.exist?(ephemeral_file_path)
  end
end
