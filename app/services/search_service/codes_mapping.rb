require 'csv'

class SearchService
  module CodesMapping
    def self.check(query)
      first_8 = query[0..7]
      last_n = query[8..-1]
      mapping = data[first_8]

      "#{mapping}#{last_n}" if mapping
    end

    private

    def self.data
      Rails.cache.fetch('codes-mapping', expires_in: 24.hours) do
        mappings = CSV.read(File.join(Rails.root, 'db', 'codes-mapping.csv'), col_sep: ';')
        mappings.to_h
      end
    end
  end
end
