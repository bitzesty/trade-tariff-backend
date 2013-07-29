class ChiefImporter < TariffImporter
  class Entry
    class << self
      def build(data = [])
        if data.present? && data.any?
          case data[0]
          when ChiefImporter.start_mark
            ChiefImporter::StartEntry.new(data)
          when ChiefImporter.end_mark
            ChiefImporter::EndEntry.new(data)
          else
            ChiefImporter::ChangeEntry.new(data)
          end
        end
      end

      # Entry is an object factory, use Entry.build to get appropriate Entry
      # object back.
      private :new
    end
  end
end
