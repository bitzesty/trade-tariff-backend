require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  let!(:update_1) { create :chief_update, :pending, issue_date: Date.yesterday, filename: "#{Date.yesterday}" }
  let!(:update_2) { create :chief_update, :pending, issue_date: Date.today, filename: "#{Date.today}" }
  let!(:taric_update) { create :taric_update, :pending, issue_date: 2.days.ago, filename: "#{2.days.ago}" }


  describe '.apply' do
    context 'when chief import fails' do
      before do
        ChiefImporter.any_instance.should_receive(:import).and_raise(ChiefImporter::ImportException)
        TariffImporter.any_instance.should_receive(:file_exists?).and_return true
        TariffSynchronizer::BaseUpdate.any_instance.should_receive(:file_exists?).and_return true
        TariffSynchronizer::TaricUpdate.any_instance.should_receive(:apply).and_return true
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end

      it 'update gets marked as failed' do
        rescuing { TariffSynchronizer.apply }
        update_1.reload.should be_failed
        update_2.reload.should be_pending
      end
    end

    context 'when taric import fails' do
      before do
        TaricImporter.any_instance.should_receive(:import).and_raise(TaricImporter::ImportException)
        TariffImporter.any_instance.should_receive(:file_exists?).and_return true
        TariffSynchronizer::BaseUpdate.any_instance.should_receive(:file_exists?).and_return true
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end

      it 'update gets marked as failed' do
        rescuing { TariffSynchronizer.apply }
        update_1.reload.should be_pending
        update_2.reload.should be_pending
        taric_update.reload.should be_failed
      end
    end

    context 'when imports go correct' do
      it 'applies missing updates' do
        # TariffSynchronizer.apply
        # update_1.reload.should be_applied
        # update_2.reload.should be_applied
        # taric_update.reload.should be_applied
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

    context 'with date passed as string' do
      let!(:older_update)  {
        create :taric_update, :applied, issue_date: Date.new(2009,10,10)
      }

      before {
        TariffSynchronizer.rollback("1/1/2010", true)
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
