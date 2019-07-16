class GenerateCoverPdfWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform
    setup_cover_object

    make_logger

    generate_and_upload
  end

  def setup_cover_object
    file_name = "00-cover.pdf"
    @pdf_file_path = File.join("public", "pdf", "tariff", "chapters", file_name)
    @dir, @base = File.split(@pdf_file_path)
    return if File.exist?(@dir)

    begin
      FileUtils.mkpath(@dir)
    rescue SystemCallError => e
      logger.warn e
    end
  end

  def make_logger
    log_dir = File.join(Rails.root, "log", "pdf")
    unless File.exist?(log_dir)
      begin
        FileUtils.mkpath(log_dir)
      rescue SystemCallError => e
        logger.warn e
      end
    end
    @logger ||= Logger.new(File.join(log_dir, "#{batch.bid}.log"))
    @logger.progname = batch.bid
  end

  def generate_and_upload
    if File.directory?(@dir)
      make_cover_pdf
      queue_for_upload
    else
      logger.info "PDF #{@base} failed: Could not find #{@dir}"
    end
  end

  def make_cover_pdf
    start = Time.now.to_i
    pdf = Uktt::Pdf.new
    pdf.config = { filepath: @pdf_file_path }
    logger.info "PDF cover started: #{@pdf_file_path}"
    pdf.make_cover
    logger.info "PDF cover saved locally: #{@pdf_file_path}"
    @logger.info ['cover', 'cover', (Time.now.to_i - start)]
  end

  def queue_for_upload
    if File.exist?(@pdf_file_path)
      batch.jobs do
        UploadChapterPdfWorker.perform_async(@pdf_file_path)
      end
    else
      logger.error "#{@pdf_file_path} not found"
    end
  end
end
