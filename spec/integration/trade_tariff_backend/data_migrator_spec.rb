require 'spec_helper'

describe TradeTariffBackend::DataMigrator do
  before { TradeTariffBackend::DataMigrator.migrations = [] }

  describe '#migrate' do
    context 'successful run' do
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

    context 'run with errors' do
      before {
        TradeTariffBackend::DataMigrator.migration do
          up do
            applicable   { Language.dataset.none? }
            apply        {
              Language.unrestrict_primary_key
              Language.create(language_id: 'GB')
              Language.create(language_id: 'ES')
              Language.restrict_primary_key
            }
          end
        end
      }

      it 'executes migrations in transactions' do
        Language.should_receive(:restrict_primary_key).and_raise(ArgumentError.new)

        rescuing { TradeTariffBackend::DataMigrator.migrate }

        expect(Language.count).to eq 0
      end
    end
  end

  describe '#rollback' do
    context 'successful run' do
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

    context 'run with errors' do
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
            apply {
              Language.dataset.where(language_id: 'GB').destroy
              Language.restrict_primary_key
            }
          end
        end

        TradeTariffBackend::DataMigrator.migrate
      }

      it 'executes migrations in transactions' do
        Language.should_receive(:restrict_primary_key).and_raise(StandardError)

        rescuing { TradeTariffBackend::DataMigrator.rollback }

        expect(Language.count).to eq 1
      end
    end
  end
end
