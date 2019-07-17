module Api
  module V2
    class PrintController < ApiController
      include PaasS3

      before_action :set_up_s3_bucket

      def index
        @files = @bucket.objects.select { |f| f.key =~ /UK-Trade-Tariff-/ }
                                .map { |obj| printed_pdf(obj) }
                                .sort_by(&:date)
                                .reverse
        render json: Api::V2::PrintSerializer.new(@files).serializable_hash
      end

      def chapters
        @chapters =  @bucket.objects.select { |f| f.key =~ %r{chapters/} }
                                    .map { |obj| printed_pdf(obj) }
                                    .sort_by(&:id)
        render json: Api::V2::PrintSerializer.new(@chapters).serializable_hash
      end

      def latest
        @file = @bucket.objects.select { |f| f.key =~ /UK-Trade-Tariff-/ }
                                .map { |obj| printed_pdf(obj) }
                                .max_by(&:date)
        render json: Api::V2::PrintSerializer.new(@file).serializable_hash
      end

      private

      def set_up_s3_bucket
        @bucket = initialize_s3
      end

      def printed_pdf(obj)
        pdf = Print.new
        pdf.id = obj.key
        pdf.url = url(obj.key)
        pdf.date = obj.last_modified
        pdf
      end

      def url(pdf_file_path)
        @dir, @key = File.split(pdf_file_path)
        @dir = '' if @dir == '.'
        initialize_s3(pdf_file_path)
        @s3_obj.public_url
      end
    end
  end
end
