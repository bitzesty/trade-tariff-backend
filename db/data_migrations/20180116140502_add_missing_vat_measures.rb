TradeTariffBackend::DataMigrator.migration do
  name 'Add missing VAT measures'

  MISSING_VAT_MEASURES = [
    [ "2007993903", "VT Z", "01.10.2014" ],
    [ "3907100090", "VT S", "01.07.2016" ],
    [ "7214200010", "VT S", "01.01.2016" ],
    [ "7225401220", "VT S", "01.02.2017" ],
    [ "7225401295", "VT S", "01.01.2017" ],
    [ "7225401520", "VT S", "01.02.2017" ],
    [ "7225401595", "VT S", "01.02.2017" ],
    [ "7226200020", "VT S", "01.02.2017" ],
    [ "7226200095", "VT S", "01.02.2017" ],
    [ "7228302010", "VT S", "01.01.2016" ],
    [ "7228302090", "VT S", "01.01.2016" ],
    [ "7228304110", "VT S", "01.01.2016" ],
    [ "7228304190", "VT S", "01.01.2016" ],
    [ "7228304910", "VT S", "01.01.2016" ],
    [ "7228304990", "VT S", "01.01.2016" ],
    [ "7228306110", "VT S", "01.01.2016" ],
    [ "7228306190", "VT S", "01.01.2016" ],
    [ "7228306910", "VT S", "01.01.2016" ],
    [ "7228306990", "VT S", "01.01.2016" ],
    [ "7228307010", "VT S", "01.01.2016" ],
    [ "7228307090", "VT S", "01.01.2016" ],
    [ "7228308910", "VT S", "01.01.2016" ],
    [ "7228308990", "VT S", "01.01.2016" ]
  ]

  up do
    applicable {
      MISSING_VAT_MEASURES.any? do |measure_candidate_ops|
        find_measure_by(measure_candidate_ops).blank?
      end
    }

    apply {
      #
      # Examples of 'MFCM' records in /data/chief/*.txt:
      #
      # "MFCM","01/07/2012:00:00:00","I","VT","S","B00",null,null,null,"21/06/2012:09:01:00","38123080 65","N","N","N"
      #
      # "MFCM","01/07/2012:00:00:00","I","VT","Z","B00",null,null,null,"21/06/2012:09:01:00","03054410 00","Y","N","N"
      #
      # "MFCM","01/01/2018:00:00:00","I","VT","Z","B00",null,null,null,"21/12/2017:08:31:00","03021180 90","Y","N","N"
      #
      # Adding of measures will be modifying primary key (fe_tsmp - aka validity_start_date)
      # so unrestricting it for Chief::Mfcm.
      #
      Chief::Mfcm.unrestrict_primary_key

      added_list = []
      skipped_list = []
      candidate_measures = []

      MISSING_VAT_MEASURES.map do |measure_candidate_ops|
        existing_record = find_measure_by(measure_candidate_ops)

        if existing_record.present?
          debug_it("[#{measure_candidate_ops}] measure already in system! Skipping...")

          skipped_list << measure_candidate_ops[0]
        else
          debug_it("[#{measure_candidate_ops}] measure is missing! Adding...")

          mfcm = Chief::Mfcm.new(
            mfcm_ops(measure_candidate_ops)
          )

          candidate_measures << ChiefTransformer::CandidateMeasure.new(
            mfcm: mfcm,
            tame: mfcm.tame,
            operation: :create,
            operation_date: Date.today
          )

          added_list << measure_candidate_ops[0]
        end
      end

      if candidate_measures.present?
        candidates = ChiefTransformer::CandidateMeasure::Collection.new(candidate_measures)
        debug_it("#{candidate_measures.count} candidate measures detected!")

        candidates.validate
        debug_it("#{candidate_measures.count} candidate measures passed validation!")

        candidates.persist
        debug_it("#{candidate_measures.count} candidate measures persisted!")

        debug_it("Script completed!")

        added_list.map do |item|
          debug_it("  https://www.trade-tariff.service.gov.uk/trade-tariff/commodities/#{clean_up_whitespaces(item)}")
        end

        debug_it("  - skipped (#{skipped_list.size}): #{skipped_list.join(', ')}")
      else
        debug_it("No any measure candidates found!")
      end

      #
      # Restricting it for Chief::Mfcm back.
      #
      Chief::Mfcm.restrict_primary_key
    }
  end

  down do
    applicable {
      MISSING_VAT_MEASURES.any? do |measure_candidate_ops|
        find_measure_by(measure_candidate_ops).present?
      end
    }

    apply {
      deleted_list = []

      MISSING_VAT_MEASURES.map do |measure_candidate_ops|
        existing_record = find_measure_by(measure_candidate_ops)

        if existing_record.present?
          debug_it("[#{measure_candidate_ops}] measure detected! Removing...")

          existing_record.destroy
          deleted_list << measure_candidate_ops[0]
        else
          debug_it("[#{measure_candidate_ops}] measure is missing! Skipping...")
        end
      end

      debug_it("Script completed!")
      debug_it("  - deleted_list (#{deleted_list.size}): #{deleted_list.join(', ')}")
    }
  end

  def mfcm_ops(measure_candidate_ops)
    commodity_code = measure_candidate_ops[0]
    msrgp_code, msr_type = measure_candidate_ops[1].split(" ")
    validity_start_date = measure_candidate_ops[2].to_datetime

    ops = {
      fe_tsmp: validity_start_date,
      amend_indicator: "I",
      msrgp_code: msrgp_code,
      msr_type: msr_type,
      tty_code: "B00",
      tar_msr_no: nil,
      le_tsmp: nil,
      audit_tsmp: nil,
      cmdty_code: commodity_code,
      cmdty_msr_xhdg: (msr_type == "Z" ? "Y" : "N"),
      null_tri_rqd: "N",
      exports_use_ind: "N"
    }

    debug_it("[#{commodity_code} - '#{msrgp_code}#{msr_type}'] options: #{ops.inspect}")

    #
    # Other options will be assigned by default:
    #
    #   geographical_area_id: "1011" # "ERGA OMNES"
    #   generating_regulation_code: "I9999/YY 31/12/1971 1971-12-31"
    #   measure_generating_regulation_id: "IYY99990"
    #   generating_regulation_code: "I9999/YY"
    #
    # and footnotes:
    #
    #   VTS: "03020 UK VAT standard rate"
    #
    #   VTZ: "03026 UK VAT zero rate"
    #

    ops
  end

  def find_measure_by(measure_candidate_ops)
    Measure.find(
      goods_nomenclature_item_id: measure_candidate_ops[0],
      measure_type_id: clean_up_whitespaces(measure_candidate_ops[1])
    )
  end

  def clean_up_whitespaces(v)
    v.gsub(" ", "")
  end

  def debug_it(message)
    puts ""
    puts "-" * 100
    puts " #{message}"
    puts "-" * 100
    puts ""
  end
end
