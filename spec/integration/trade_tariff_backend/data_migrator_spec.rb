require 'spec_helper'

describe TradeTariffBackend::DataMigrator do
  describe '#migrate' do
    before {
      TradeTariffBackend::DataMigrator.migration do
        up do
          applicable   { Language.dataset.none? }
          apply        {
            Language.unrestrict_primary_key
            Language.create(language_id: 'GB')
          }
        end
      end
    }

    it 'executes pending migrations' do
      TradeTariffBackend::DataMigrator.migrate

      expect(Language.count).to eq 1
    end
  end

  describe '#rollback' do
    before {
      TradeTariffBackend::DataMigrator.migration do
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

      TradeTariffBackend::DataMigrator.migrate
    }

    it 'rolls back applied migration' do
      TradeTariffBackend::DataMigrator.rollback

      expect(Language.count).to eq 0
    end
  end
end
