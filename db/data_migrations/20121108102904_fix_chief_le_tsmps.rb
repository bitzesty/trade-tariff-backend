TradeTariffBackend::DataMigrator.migration do
  name "Fix CHIEF le_tsmps"

  up do
    applicable {
      Chief::Tame.where("le_tsmp = '0000-00-00 00:00:00'").any? ||
      Chief::Mfcm.where("le_tsmp = '0000-00-00 00:00:00'").any?
    }
    apply {
      Chief::Tame.where("le_tsmp = '0000-00-00 00:00:00'").update(le_tsmp: nil)
      Chief::Mfcm.where("le_tsmp = '0000-00-00 00:00:00'").update(le_tsmp: nil)
    }
  end

  down do
    applicable {
      Chief::Tame.where("le_tsmp IS NULL").any? ||
      Chief::Mfcm.where("le_tsmp IS NULL").any?
    }
    apply {
      Chief::Tame.where("le_tsmp IS NULL").update(le_tsmp: nil)
      Chief::Mfcm.where("le_tsmp IS NULL").update(le_tsmp: nil)
    }
  end
end
