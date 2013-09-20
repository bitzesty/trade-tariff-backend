TradeTariffBackend::DataMigrator.migration do
  name "Fix National Certificate Type validity period"

  VALIDITY_START_DATE = Date.new(1971,12,13)

  up do
    applicable {
      CertificateType::Operation.where(
        certificate_type_code: '9',
        validity_start_date: VALIDITY_START_DATE
      ).none?
    }

    apply {
      CertificateType::Operation.where(
        certificate_type_code: '9',
      ).update(
        validity_start_date: VALIDITY_START_DATE
      )
    }
  end

  down do
    applicable {
      CertificateType::Operation.where(
        certificate_type_code: '9',
        validity_start_date: nil
      ).none?
    }

    apply {
      CertificateType::Operation.where(
        certificate_type_code: '9',
      ).update(
        validity_start_date: nil
      )
    }
  end
end
