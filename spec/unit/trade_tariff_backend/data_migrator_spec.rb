require 'spec_helper'

describe TradeTariffBackend::DataMigrator do
  before { TradeTariffBackend::DataMigrator.migrations = [] }

  describe '#migration' do
    it 'defines a new migration' do
      TradeTariffBackend::DataMigrator.migration do
        desc "Foo"
      end

      expect(TradeTariffBackend::DataMigrator.migrations.first.desc).to eq 'Foo'
    end
  end

  describe '#migrations' do
    context 'some migrations defined' do
      it 'returns migration array' do
        example_migration = TradeTariffBackend::DataMigrator.migration do
          desc "Foo"
        end

        expect(TradeTariffBackend::DataMigrator.migrations).to include example_migration
      end
    end

    context 'no migrations defined' do
      it 'returns empty array' do
        expect(TradeTariffBackend::DataMigrator.migrations).to eq []
      end
    end
  end

  describe '#migrate' do
    let(:migration) { double("Migration", can_rollup?: true).as_null_object }
    let(:applied_migration) { double("Applied Migration", can_rollup?: false).as_null_object }

    before {
      TradeTariffBackend::DataMigrator.migrations = [migration, applied_migration]
    }

    it 'applies all pending migrations' do
      TradeTariffBackend::DataMigrator.migrate

      expect(migration).to have_received :up
      expect(migration).to have_received :apply
    end

    it 'does not apply applied migrations' do
      TradeTariffBackend::DataMigrator.migrate

      expect(applied_migration).not_to have_received :up
      expect(applied_migration).not_to have_received :apply
    end
  end

  describe '#rollback' do
    let(:migration) {
      double("Migration", can_rollup?: true).as_null_object
    }

    let(:applied_migration) {
      double("Applied Migration", can_rollup?: false).as_null_object
    }

    let(:other_applied_migration) {
      double("Other Applied Migration", can_rollup?: false).as_null_object
    }

    it 'rolls back last applied migration' do
      TradeTariffBackend::DataMigrator.migrations = [migration, applied_migration]
      TradeTariffBackend::DataMigrator.rollback

      expect(applied_migration).to have_received :down
      expect(applied_migration).to have_received :apply
    end

    it 'does not rollback two applied migrations' do
      TradeTariffBackend::DataMigrator.migrations = [
        migration, other_applied_migration, applied_migration
      ]
      TradeTariffBackend::DataMigrator.rollback

      expect(other_applied_migration).not_to have_received :down
      expect(other_applied_migration).not_to have_received :apply
    end

    it 'does not rollback non applied migrations' do
      TradeTariffBackend::DataMigrator.migrations = [applied_migration, migration]
      TradeTariffBackend::DataMigrator.rollback

      expect(migration).to have_received :down
      expect(migration).to have_received :apply
    end
  end

  describe '#redo' do
    it 'rolls back last applied migration' do
      applied_migration = double("Applied Migration", can_rollup?: false).as_null_object
      TradeTariffBackend::DataMigrator.migrations = [applied_migration]

      TradeTariffBackend::DataMigrator.redo

      expect(applied_migration).to have_received :down
      expect(applied_migration).to have_received :apply
    end

    it 'migrates rolled back migration' do
      applied_migration = double("Applied Migration", can_rollup?: true).as_null_object
      TradeTariffBackend::DataMigrator.migrations = [applied_migration]

      TradeTariffBackend::DataMigrator.redo

      expect(applied_migration).to have_received :up
      expect(applied_migration).to have_received(:apply).twice
    end
  end
end
