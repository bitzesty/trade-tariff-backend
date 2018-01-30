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
      helper_klass.up_applicable?(MISSING_VAT_MEASURES)
    }

    apply {
      helper_klass.up_apply(MISSING_VAT_MEASURES)
    }
  end

  down do
    applicable {
      helper_klass.down_applicable?(MISSING_VAT_MEASURES)
    }

    apply {
      helper_klass.down_apply(MISSING_VAT_MEASURES)
    }
  end

  def helper_klass
    ::TradeTariffBackend::DataMigration::Helpers::VatMeasures::ManualAddition
  end
end
