require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  describe '#apply', truncation: true do
    let(:example_date)  { Date.today }
    let!(:taric_update) { create :taric_update, example_date: example_date }
    let!(:chief_update) { create :chief_update, example_date: example_date }


    before {
      prepare_synchronizer_folders
      create_taric_file :pending, example_date
      create_chief_file :pending, example_date
    }

    after  {
      purge_synchronizer_folders
    }


    context 'when chief fails' do
      before do
        ChiefImporter.any_instance.should_receive(
          :import
        ).and_raise ChiefImporter::ImportException
      end

      it 'should mark chief update as failed' do
        taric_update.should be_pending
        chief_update.should be_pending
        rescuing { TariffSynchronizer.apply }
        taric_update.reload.should be_applied
        chief_update.reload.should be_failed
      end
    end

    context 'when taric fails' do
      before do
        TaricImporter.any_instance.should_receive(
          :import
        ).and_raise TaricImporter::ImportException
      end

      it 'should mark taric update as failed' do
        taric_update.should be_pending
        chief_update.should be_pending
        rescuing { TariffSynchronizer.apply }
        taric_update.reload.should be_failed
        chief_update.reload.should be_pending
      end
    end

    context 'when everything is fine' do
      it 'applies missing updates' do
        TariffSynchronizer.apply
        taric_update.reload.should be_applied
        chief_update.reload.should be_applied
      end
    end

    context 'but elasticsearch is buggy' do
      before do
        TaricImporter::Transaction.any_instance.should_receive(
          :persist
        ).and_raise Elasticsearch::Transport::Transport::SnifferTimeoutError
      end

      it 'stops syncing' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
        taric_update.reload.should_not be_applied
        chief_update.reload.should_not be_applied
      end
    end

    context 'but we have a timeout' do
      before do
        TaricImporter::Transaction.any_instance.should_receive(
          :persist
        ).and_raise Timeout::Error
      end

      it 'stops syncing' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
        taric_update.reload.should_not be_applied
        chief_update.reload.should_not be_applied
      end
    end
  end

  describe '.rollback' do
    let!(:measure) { create :measure, operation_date: Date.today }
    let!(:update)  { create :chief_update, :applied, issue_date: Date.today }
    let!(:mfcm)    { create :mfcm, origin: update.filename }

    context 'successful run' do
      before {
        TariffSynchronizer.rollback(Date.yesterday, true)
      }

      it 'removes entries from oplog tables' do
        expect { Measure.none? }.to be_true
      end

      it 'marks Chief and Taric updates as pending' do
        update.reload.should be_pending
      end

      it 'removes imported Chief records entries' do
        expect { Chief::Mfcm.none? }.to be_true
      end
    end

    context 'encounters an exception' do
      before {
        Measure.should_receive(:operation_klass).and_raise(StandardError)

        rescuing { TariffSynchronizer.rollback(Date.yesterday, true) }
      }

      it 'does not remove entries from oplog derived tables' do
        expect { Measure.any? }.to be_true
      end

      it 'leaves Chief and Taric updates in applid state' do
        update.reload.should be_applied
      end

      it 'removes imported Chief records entries' do
        expect { Chief::Mfcm.any? }.to be_true
      end
    end

    context 'forced to redownload by default' do
      before {
        TariffSynchronizer.rollback(Date.yesterday)
      }

      it 'removes entries from oplog derived tables' do
        expect { Measure.none? }.to be_true
      end

      it 'deletes Chief and Taric updates' do
        expect { update.reload }.to raise_error Sequel::Error
      end

      it 'removes imported Chief records entries' do
        expect { Chief::Mfcm.none? }.to be_true
      end
    end

    context 'with date passed as string' do
      let!(:older_update)  {
        create :taric_update, :applied, issue_date: 2.days.ago
      }

      before {
        TariffSynchronizer.rollback(Date.yesterday)
      }

      it 'removes entries from oplog derived tables' do
        expect { Measure.none? }.to be_true
      end

      it 'deletes Chief and Taric updates' do
        expect { update.reload }.to raise_error Sequel::Error
      end

      it 'removes imported Chief records entries' do
        expect { Chief::Mfcm.none? }.to be_true
      end

      it 'does not remove earlier updates (casts date as string to date)' do
        expect { older_update.reload }.not_to raise_error
      end
    end
  end
end
