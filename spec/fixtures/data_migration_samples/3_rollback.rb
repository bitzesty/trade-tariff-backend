TradeTariffBackend::DataMigrator.migration do
  name "Rollback"

  up do
    applicable   { Language.dataset.none? }
    apply        {
      Language.unrestrict_primary_key
      Language.create(language_id: 'GB')
    }
  end

  down do
    applicable { Language.dataset.where(language_id: 'GB').any? }
    apply { Language.dataset.where(language_id: 'GB').destroy }
  end
end
