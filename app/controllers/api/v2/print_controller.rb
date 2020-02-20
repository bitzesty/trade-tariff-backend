module Api
  module V2
    class PrintController < ApiController
      include PaasS3

      before_action :set_up_s3_bucket

      def index
        @result = filter_by(/UK-Trade-Tariff-/).sort_by(&:date).reverse
        render_result
      end

      def chapters
        @result = filter_by(%r{^chapters/}).sort_by(&:id)
        render_result
      end

      def latest
        @result = filter_by(/UK-Trade-Tariff-latest/).max_by(&:date)
        render_result
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
        initialize_s3(pdf_file_path)
        @s3_obj.public_url
      end

      def render_result
        @result = [@result] unless @result.is_a?(Array)
        render json: Api::V2::PrintSerializer.new(@result).serializable_hash
      end

      def filter_by(filter)
        @bucket.objects.select { |f| f.key =~ filter }
                       .map { |obj| printed_pdf(obj) }
      end
    end
  end
end
