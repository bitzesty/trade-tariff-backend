require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
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
      before { TariffSynchronizer.should_receive(:sync_variables_set?).and_return(true) }

      it 'invokes update downloading/syncing on all update types' do
        TariffSynchronizer::TaricUpdate.should_receive(:sync).and_return(true)
        TariffSynchronizer::ChiefUpdate.should_receive(:sync).and_return(true)

        TariffSynchronizer.download
      end
    end

    context 'sync variables are not set' do
      before {
        TariffSynchronizer.username = nil
        TariffSynchronizer.password = nil
        TariffSynchronizer.host = nil
      }

      it 'does not start sync process' do
        TariffSynchronizer::TaricUpdate.should_receive(:sync).never
        TariffSynchronizer::ChiefUpdate.should_receive(:sync).never

        TariffSynchronizer.download
      end
    end

    context 'with download exceptions' do
      before {
        TariffSynchronizer.should_receive(:sync_variables_set?).and_return(true)

        Curl::Easy.any_instance
                  .should_receive(:perform)
                  .and_raise(Curl::Err::HostResolutionError) }

      it 'raises original exception ending process' do
        expect { TariffSynchronizer.download }.to raise_error Curl::Err::HostResolutionError
      end
    end
  end

  describe '.apply' do
    let(:update_1) { double('update', file_name: Date.yesterday, update_priority: 1).as_null_object }
    let(:update_2) { double('update', file_name: Date.today, update_priority: 1).as_null_object }
    let(:pending_updates) { [update_1, update_2] }


    context 'success scenario' do
      before {
        TariffSynchronizer::PendingUpdate.should_receive(:all).and_return(pending_updates)
      }

      it 'all pending updates get applied' do
        pending_updates.each {|update|
          update.should_receive(:apply).and_return(true)
        }

        TariffSynchronizer.apply
      end
    end

    context 'failure scenario' do
      before do
        TariffSynchronizer::PendingUpdate.should_receive(:all).and_return(pending_updates)

        update_1.should_receive(:apply).and_raise(TaricImporter::ImportException)
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error TaricImporter::ImportException
      end

      it 'update gets marked as failed' do
        update_1.should_receive(:mark_as_failed).and_return(true)
        update_2.should_receive(:apply).never

        rescuing { TariffSynchronizer.apply }
      end
    end

    context 'with failed updates present' do
      let!(:failed_update)  { create :taric_update, :failed }

      it 'does not apply pending updates' do
        TariffSynchronizer::PendingUpdate.should_receive(:all).never

        TariffSynchronizer.apply
      end
    end
  end

  describe '.rebuild' do
    it 'invokes rebuild on TaricUpdate and ChiefUpdate' do
      TariffSynchronizer::TaricUpdate.should_receive(:rebuild)
      TariffSynchronizer::ChiefUpdate.should_receive(:rebuild)

      TariffSynchronizer.rebuild
    end
  end
end
