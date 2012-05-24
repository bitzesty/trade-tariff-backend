class Scrape
  class Persistance
    class << self
      def process(record)
        s = Scrape.new(scrape_id: record.code, heading: record.is_a?(Heading))
        tables = s.process_tables

        # process conditions
        process_footnotes(tables["footnotes"])
        process_measures(record, tables['third_country'])
        process_measures(record, tables['specific_countries'], true)
      end

      def process_headings
        # Find Headings without commodities, add data for them first
        Heading.limit(55).each do |h|
          if h.commodities.blank?
            process(h)
          end
        end
      end

      def process_footnotes(data)
        data.each do |footnote|
          Footnote.find_or_create_by(code: footnote["Code"].normalize, description: footnote["Description"].normalize)
        end
      end

      def process_measures(record, data, country_specific = false)
        data.each do |measure_data|
          measure = Measure.new
          measure.origin = measure_data["Flag"].match(/\/images\/(.*)\..*$/)[1]
          measure.measure_type = measure_data["Measure Type"].normalize
          measure.duty_rates = measure_data["Duty rates"].normalize
          measure.legal_act = LegalAct.find_or_create_by(code: measure_data["Legal Act"].normalize)
          measure.save

          measure_data["Exclusions"].split(",").each do |country|
            c = Country.find_or_create_by(name: country,
                                          iso_code: Scrape::GeoHelper.country_by_name(country))

            measure.excluded_countries << c
          end

          if measure_data.has_key?("Additional codes")
            measure_data["Additional codes"].normalize.split(",").each do |additional_code|
              ac = AdditionalCode.find_or_create_by(code: additional_code)

              measure.additional_codes << ac
            end
          end

          if measure_data.has_key?("Footnote")
            measure_data["Footnote"].normalize.split(",").each do |footnote|
              if fn = Footnote.where(code: footnote).first
                measure.footnotes << fn
              end
            end
          end

          if country_specific
            region_name = measure_data["Country"].normalize

            region = Country.where(name: region_name).first
            if country.blank?
              region = CountryGroup.where(name: region_name).first
            end

            measure.region = region
          end

          record.measures << measure
        end
      end
    end
  end
end
