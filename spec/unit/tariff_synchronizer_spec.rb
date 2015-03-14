require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer, truncation: true do
  describe '.initial_update_for' do
    # helper method where update type is a param
    it 'returns initial update day for specific update type' do
      expect(TariffSynchronizer.initial_update_for(:taric)).to eq(TariffSynchronizer.taric_initial_update)
      expect(TariffSynchronizer.initial_update_for(:chief)).to eq(TariffSynchronizer.chief_initial_update)
      expect { TariffSynchronizer.initial_update_for(:non_existent) }.to raise_error
    end
  end

  describe '.download' do
    context 'sync variables are set' do
      before {
        expect(TariffSynchronizer).to receive(:sync_variables_set?).and_return(true)
      }

      it 'invokes update downloading/syncing on all update types' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:sync).and_return(true)
        expect(TariffSynchronizer::ChiefUpdate).to receive(:sync).and_return(true)

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
        expect(TariffSynchronizer::TaricUpdate).to_not receive(:sync)
        expect(TariffSynchronizer::ChiefUpdate).to_not receive(:sync)

        TariffSynchronizer.download
      end
    end

    context 'with download exceptions' do
      before {
        expect(TariffSynchronizer).to receive(:sync_variables_set?).and_return(true)

        allow_any_instance_of(Curl::Easy).to receive(:perform)
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
        allow(TariffSynchronizer).to receive(:update_range_in_days).and_return([Date.yesterday, Date.today])
        expect(TariffSynchronizer::TaricUpdate).to receive(:pending_at).with(update_1.issue_date).and_return([update_1])
        expect(TariffSynchronizer::TaricUpdate).to receive(:pending_at).with(update_2.issue_date).and_return([update_2])
      }

      it 'all pending updates get applied' do

        pending_updates.each {|update|
          expect(update).to receive(:apply).and_return(true)
        }

        TariffSynchronizer.apply
      end
    end

    context 'failure scenario' do
      before do
        allow(TariffSynchronizer).to receive(:update_range_in_days).and_return([Date.yesterday, Date.today])
        expect(TariffSynchronizer::TaricUpdate).to receive(:pending_at).with(update_1.issue_date).and_return([update_1])

        expect(update_1).to receive(:apply).and_raise(Sequel::Rollback)
      end

      it 'transaction gets rolled back' do
        expect { TariffSynchronizer.apply }.to raise_error Sequel::Rollback
      end

      it 'update gets marked as failed' do
        expect(update_2).to receive(:apply).never

        rescuing { TariffSynchronizer.apply }
      end
    end

    context 'with failed updates present' do
      let!(:failed_update)  { create :taric_update, :failed }

      it 'does not apply pending updates' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:pending_at).never
        expect(TariffSynchronizer::ChiefUpdate).to receive(:pending_at).never
        expect { TariffSynchronizer.apply }.to raise_error TariffSynchronizer::FailedUpdatesError
      end
    end
  end

  describe '.rebuild' do
    it 'invokes rebuild on TaricUpdate and ChiefUpdate' do
      expect(TariffSynchronizer::TaricUpdate).to receive(:rebuild)
      expect(TariffSynchronizer::ChiefUpdate).to receive(:rebuild)

      TariffSynchronizer.rebuild
    end
  end
end
