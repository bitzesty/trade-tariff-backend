TradeTariffBackend::DataMigrator.migration do
  name "Add missing VAT measures for commodities '3802 9000 11', '3824 9992 35', '7225 9900 40'"

  MISSING_VAT_MEASURES = [
    [ "3802900011", "VT S", "30.01.2018" ],
    [ "3824999235", "VT S", "30.01.2018" ],
    [ "7225990040", "VT S", "30.01.2018" ]
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
