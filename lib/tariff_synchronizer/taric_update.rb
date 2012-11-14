require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class TaricUpdate < BaseUpdate
    self.update_priority = 2

    class << self
      def download(date)
        taric_update_url_for(date).tap do |taric_update_url|
          if taric_update_url.present?
            ActiveSupport::Notifications.instrument("download_taric.tariff_synchronizer", date: date,
                                                                                          url: taric_update_url) do
              download_content(taric_update_url).tap { |response|
                create_entry(date, response)
              }
            end
          # We will be retrying a few more times today, so do not create
          # missing record until we are sure
          elsif date < Date.today
            create_update_entry(date, BaseUpdate::MISSING_STATE)
            ActiveSupport::Notifications.instrument("not_found.tariff_synchronizer", date: date,
                                                                                     url: taric_query_url_for(date))
          end
        end
      end

      def file_name_for(date)
        "#{date}_TGB#{date.strftime("%y")}#{date.yday}.xml"
      end

      def update_type
        :taric
      end

      def rebuild
        Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'taric', '*.xml')].each do |file_path|
          date, file_name = parse_file_path(file_path)

          create_update_entry(Date.parse(date), BaseUpdate::PENDING_STATE)
        end
      end
    end

    def apply
      if super
        ActiveSupport::Notifications.instrument("apply_taric.tariff_synchronizer", filename: filename) do
          TariffImporter.new(file_path, TaricImporter).import

          mark_as_applied
        end
      end
    end

    private

    def self.taric_update_name_for(date)
      taric_query_url = taric_query_url_for(date)

      ActiveSupport::Notifications.instrument("get_taric_update_name.tariff_synchronizer", date: date,
                                                                                           url: taric_query_url) do
        response = download_content(taric_query_url)
        response.content.gsub!(/[^0-9a-zA-Z\.]/i, '') if response.success? && response.content_present?
      end
    end

    def self.taric_update_url_for(date)
      update_name = taric_update_name_for(date)

      if update_name.present?
        TariffSynchronizer.taric_update_url_template % { host: TariffSynchronizer.host,
                                                         file_name: update_name }
      end
    end

    def self.taric_query_url_for(date)
      date_query = Date.parse(date.to_s).strftime("%Y%m%d")
      TariffSynchronizer.taric_query_url_template % { host: TariffSynchronizer.host,
                                                      date: date_query}
    end
  end
end
