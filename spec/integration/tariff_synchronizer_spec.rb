require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  let!(:update_1) { create :chief_update, :pending, issue_date: Date.yesterday, filename: "#{Date.yesterday}" }
  let!(:update_2) { create :chief_update, :pending, issue_date: Date.today, filename: "#{Date.today}" }

  describe '.apply' do
    context 'failure scenario' do
      before do
        TariffSynchronizer::PendingUpdate.any_instance
                                         .should_receive(:apply)
                                         .once # subsequent updates are not applied
                                         .and_raise(ChiefImporter::ImportException)
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error ChiefImporter::ImportException
      end

      it 'update gets marked as failed' do
        rescuing { TariffSynchronizer.apply }
        update_1.reload.should be_failed
      end
    end
  end

  describe '.rollback' do
    let!(:measure) { create :measure, operation_date: Date.today }
    let!(:update)  { create :chief_update, :applied, issue_date: Date.today }
    let!(:mfcm)    { create :mfcm, origin: update.filename }

    context 'successful run' do
      before {
        TariffSynchronizer.rollback(Date.new(2010,1,1))
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

        rescuing { TariffSynchronizer.rollback(Date.new(2010,1,1)) }
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

    context 'when forced to redownload' do
      before {
        TariffSynchronizer.rollback(Date.new(2010,1,1), true)
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
  end
end
