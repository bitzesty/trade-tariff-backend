require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  before do
    # Do not pollute the log file with messages from test runs
    TariffSynchronizer.logger = Logger.new('/dev/null')

    # Use default email address
    TariffSynchronizer.admin_email = "user@example.com"
  end

  describe '.initial_update_for' do
    # helper method where update type is a param
    it 'returns initial update day for specific update type' do
      TariffSynchronizer.initial_update_for(:taric).should == TariffSynchronizer.taric_initial_update
      TariffSynchronizer.initial_update_for(:chief).should == TariffSynchronizer.chief_initial_update
      expect { TariffSynchronizer.initial_update_for(:non_existent) }.to raise_error
    end
  end

  describe '.download' do
    it 'invokes update downloading/syncing on all update types' do
      TariffSynchronizer::TaricUpdate.expects(:sync).returns(true)
      TariffSynchronizer::ChiefUpdate.expects(:sync).returns(true)

      TariffSynchronizer.download
    end
  end

  describe '.apply' do
    let(:update_1) { stub_everything(date: Date.today, update_priority: 1) }
    let(:update_2) { stub_everything(date: Date.yesterday, update_priority: 2) }
    let(:pending_updates) { [update_1, update_2] }

    before {
      TariffSynchronizer::PendingUpdate.expects(:all).returns(pending_updates)
    }

    context 'success scenario' do
      it 'all pending updates get applied' do
        pending_updates.each {|update|
          update.expects(:apply).returns(true)
        }

        TariffSynchronizer.apply
      end
    end

    context 'failure scenarion' do
      before do
        update_1.expects(:apply).returns(true)
        update_2.expects(:apply).raises(TariffImporter::TaricImportException)
      end

      it 'error gets logged' do
        TariffSynchronizer.logger.expects(:error).returns(true)

        rescuing { TariffSynchronizer.apply }
      end

      it 'failed updated gets moved to failbox' do
        update_2.expects(:move_to).with(:failbox).returns(true)

        rescuing { TariffSynchronizer.apply }
      end

      it 'admin gets notified' do
        mailer_stub = stub
        mailer_stub.expects(:deliver).returns(true)
        SyncMailer.expects(:admin_notification).returns(mailer_stub)

        rescuing { TariffSynchronizer.apply }
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end
    end
  end
end
