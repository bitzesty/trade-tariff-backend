require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'
require "csv"

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    class << self
      def download(date)
        update_file_name = file_name_for(date)
        perform_download(update_file_name, chief_update_url_for(date), date)
      end

      def update_type
        :chief
      end

      def rebuild
        Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'chief', '*.txt')].each do |file_path|
          date, file_name = parse_file_path(file_path)

          create_update_entry(Date.parse(date), BaseUpdate::PENDING_STATE, Pathname.new(file_path).basename.to_s)
        end
      end

      def file_name_for(date)
        "#{date}_#{chief_file_name_for(date)}"
      end
    end

    def import!
      instrument("apply_chief.tariff_synchronizer", filename: filename) do
        ChiefImporter.new(file_path, issue_date).import

        mark_as_applied
      end

      ::ChiefTransformer.instance.invoke(:update, self)
    end

    private

    def self.validate_file!(response)
      begin
        CSV.parse(response.content)
      rescue CSV::MalformedCSVError => e
        raise InvalidContents.new(e.message, e)
      else
        true
      end
    end

    def self.chief_file_name_for(date)
      day = sprintf("%03d", date.yday)

      "KBT009(#{date.strftime("%y")}#{day}).txt"
    end

    def self.chief_update_url_for(date)
      TariffSynchronizer.chief_update_url_template % { host: TariffSynchronizer.host,
                                                       file_name: chief_file_name_for(date)}
    end
  end
end
