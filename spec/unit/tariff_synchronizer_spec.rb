require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  before do
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
    context 'sync variables are set' do
      before { TariffSynchronizer.expects(:sync_variables_set?).returns(true) }

      it 'invokes update downloading/syncing on all update types' do
        TariffSynchronizer::TaricUpdate.expects(:sync).returns(true)
        TariffSynchronizer::ChiefUpdate.expects(:sync).returns(true)

        TariffSynchronizer.download
      end
    end

    context 'sync variables are not set' do
      before {
        TariffSynchronizer.username = nil
        TariffSynchronizer.password = nil
        TariffSynchronizer.host = nil
        TariffSynchronizer.admin_email = nil
      }

      it 'does not start sync process' do
        TariffSynchronizer::TaricUpdate.expects(:sync).never
        TariffSynchronizer::ChiefUpdate.expects(:sync).never

        TariffSynchronizer.download
      end
    end
  end

  describe '.apply' do
    let(:update_1) { stub_everything(date: Date.today, update_priority: 1) }
    let(:update_2) { stub_everything(date: Date.yesterday, update_priority: 2) }
    let(:pending_updates) { [update_1, update_2] }


    context 'success scenario' do
      before {
        TariffSynchronizer::PendingUpdate.expects(:all).returns(pending_updates)
      }

      it 'all pending updates get applied' do
        pending_updates.each {|update|
          update.expects(:apply).returns(true)
        }

        TariffSynchronizer.apply
      end
    end

    context 'failure scenario' do
      before do
        TariffSynchronizer::PendingUpdate.expects(:all).returns(pending_updates)

        update_1.expects(:apply).returns(true)
        update_2.expects(:apply).raises(TaricImporter::ImportException)
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end
    end

    context 'with failed updates present' do
      let!(:failed_update)  { create :taric_update, :failed }

      it 'does not apply pending updates' do
        TariffSynchronizer::PendingUpdate.expects(:all).never

        TariffSynchronizer.apply
      end
    end
  end

  describe '.rebuild' do
    it 'invokes rebuild on TaricUpdate and ChiefUpdate' do
      TariffSynchronizer::TaricUpdate.expects(:rebuild)
      TariffSynchronizer::ChiefUpdate.expects(:rebuild)

      TariffSynchronizer.rebuild
    end
  end
end
