class GenerateChapterPdfWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def self.chapter_pdf(chapter_sid, save_immediately=false)
    chapter = Chapter.eager(:headings).where(goods_nomenclature_sid: chapter_sid).take
    pdf_name = "#{chapter.section.position.to_s.rjust(2,'0')}-#{chapter.short_code}-#{chapter.formatted_description}.pdf"
    pdf = ExportChapterPdf.new(chapter)
    if save_immediately
      pdf.save_as(pdf_name)
    else
      return pdf
    end
  end

  def perform(chapter_sid)
    setup_chapter_object(chapter_sid)

    make_logger

    generate_and_upload
  end

  def setup_chapter_object(chapter_sid)
    @chapter = Chapter.eager(:headings).where(goods_nomenclature_sid: chapter_sid).take
    file_name = "#{@chapter.section.position.to_s.rjust(2,'0')}-#{@chapter.short_code}.pdf"
    @pdf_file_path = File.join("public", "pdf", "tariff", "chapters", file_name)
    @dir, @base = File.split(@pdf_file_path)

    unless File.exists?(@dir)
      begin
        Dir.mkdir(@dir)
      rescue SystemCallError => e
        logger.warn e
      end
    end
  end

  def make_logger
    log_dir = File.join(Rails.root, "log", "pdf")
    log_file_path = File.join(log_dir, "#{batch.bid}.log")

    unless File.exists?(log_dir)
      begin
        Dir.mkdir(log_dir)
      rescue SystemCallError => e
        logger.warn e
      end
    end

    @logger ||= Logger.new(log_file_path)
    @logger.progname = batch.bid
  end

  def generate_and_upload
    if File.directory?(@dir)
      start = Time.now.to_i

      pdf = Uktt::Pdf.new
      pdf.config = {
        chapter_id: @chapter.short_code,
        filepath: @pdf_file_path,
        host: 'https://www.trade-tariff.service.gov.uk/api'
      }
      logger.info "PDF started: #{@pdf_file_path}"
      pdf.make_chapter
      logger.info "PDF saved locally: #{@pdf_file_path}"

      @logger.info [
        @chapter.short_code,
        @chapter.goods_nomenclature_sid,
        (Time.now.to_i - start)
      ]

      if File.exist?(@pdf_file_path)
        batch.jobs do
          UploadChapterPdfWorker.perform_async(@pdf_file_path)
        end
      else
        logger.error "#{@pdf_file_path} not found"
      end
    else
      logger.info "PDF #{@base} failed: Could not find #{@dir}"
    end
  end
end
