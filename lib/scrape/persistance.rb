class Scrape
  class Persistance
    class << self
      def process(record)
        s = Scrape.new(scrape_id: record.code.first(10), heading: record.is_a?(Heading))
        tables = s.process_tables

        # process conditions
        if tables['footnotes'].present?
          process_footnotes(tables["footnotes"])
          process_measures(record, tables, 'third_country')
          process_measures(record, tables, 'specific_countries', true)
        end
      end

      def process_footnotes(data)
        data.each do |footnote|
          Footnote.find_or_create_by(code: footnote["Code"].normalize,
                                     description: footnote["Description"].normalize)
        end
      end

      def process_measures(record, data, table, country_specific = false)
        data[table].each do |measure_data|
          if measure_data.keys.size > 2
            measure = Measure.new
            measure.origin = measure_data["Flag"].match(/\/images\/(.*)\..*$/)[1]
            measure.measurable = record
            measure.measure_type = measure_data["Measure Type"].normalize
            measure.duty_rates = measure_data["Duty rates"].normalize
            legal_act_code = measure_data["Legal Act"].normalize
            measure.legal_act = LegalAct.find_or_create_by(code: legal_act_code) unless legal_act_code.blank?
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

              region = if Scrape::GeoHelper.country_by_name(region_name).present?
                  Country.find_or_create_by(name: region_name,
                                            iso_code: Scrape::GeoHelper.country_by_name(region_name))
                else
                  CountryGroup.find_or_create_by(name: region_name)
              end

              measure.region = region
              measure.save
            end

            if measure_data.has_key?("Conditions") && measure_data['Conditions'].normalize.present?
              if country_specific
                data.each do |key, value|
                  if measure.region.present? && key =~ /#{measure.region}/
                    data[key].each do |condition|
                      measure.conditions.create({condition: condition['Condition'].normalize,
                                                document_code: condition['Document code'].normalize,
                                                action: condition['Action'].normalize,
                                                requirement: condition['Requirement'].normalize,
                                                duty_expression: condition['Duty expression'].normalize})
                    end
                  end
                end
              else
                data.each do |key, value|
                  if key =~ /ERGA OMNES/
                    data[key].each do |condition|
                      measure.conditions.create({condition: condition['Condition'].normalize,
                                                document_code: condition['Document code'].normalize,
                                                action: condition['Action'].normalize,
                                                requirement: condition['Requirement'].normalize,
                                                duty_expression: condition['Duty expression'].normalize})
                    end
                  end
                end
              end
            end

            record.measures << measure
          end
        end
      end
    end
  end
end
