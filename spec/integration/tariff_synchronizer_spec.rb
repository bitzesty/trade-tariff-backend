require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer do
  let!(:update_1) { create :chief_update, :pending, issue_date: Date.yesterday }
  let!(:update_2) { create :chief_update, :pending, issue_date: Date.today }

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
end
