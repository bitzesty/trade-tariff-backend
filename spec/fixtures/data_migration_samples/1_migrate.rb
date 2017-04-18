TradeTariffBackend::DataMigrator.migration do
  name "Migrate"

  up do
    applicable   { Language.dataset.none? }
    apply        {
      Language.unrestrict_primary_key
      Language.create(language_id: 'GB')
    }
  end

  down do
    applicable { }
    apply { }
  end
end
