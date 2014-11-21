require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer, truncation: true do
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
                  .stub(:perform)
                  .and_raise(Curl::Err::HostResolutionError) }

      it 'raises original exception ending process' do
        expect { TariffSynchronizer.download }.to raise_error Curl::Err::HostResolutionError
      end
    end
  end

  describe '.apply' do
    let(:update_1) { double('update', issue_date: Date.yesterday, filename: Date.yesterday) }
    let(:update_2) { double('update', issue_date: Date.today, filename: Date.today) }
    let(:pending_updates) { [update_1, update_2] }


    context 'success scenario' do
      before {
        TariffSynchronizer.stub(:update_range_in_days).and_return([Date.yesterday, Date.today])
        TariffSynchronizer::TaricUpdate.should_receive(:pending_at).with(update_1.issue_date).and_return([update_1])
        TariffSynchronizer::TaricUpdate.should_receive(:pending_at).with(update_2.issue_date).and_return([update_2])
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
        TariffSynchronizer.stub(:update_range_in_days).and_return([Date.yesterday, Date.today])
        TariffSynchronizer::TaricUpdate.should_receive(:pending_at).with(update_1.issue_date).and_return([update_1])

        update_1.should_receive(:apply).and_raise(Sequel::Rollback)
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end

      it 'update gets marked as failed' do
        update_2.should_receive(:apply).never

        rescuing { TariffSynchronizer.apply }
      end
    end

    context 'with failed updates present' do
      let!(:failed_update)  { create :taric_update, :failed }

      it 'does not apply pending updates' do
        TariffSynchronizer::TaricUpdate.should_receive(:pending_at).never
        TariffSynchronizer::ChiefUpdate.should_receive(:pending_at).never
        expect { TariffSynchronizer.apply }.to raise_error TariffSynchronizer::FailedUpdatesError
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
