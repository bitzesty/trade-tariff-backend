require 'rails_helper'
require 'tariff_synchronizer'
require 'taric_importer'

describe TariffSynchronizer do
  describe '#apply', truncation: true do
    let!(:taric_update) { create :taric_update, example_date: example_date }
    let!(:chief_update) { create :chief_update, example_date: example_date }

    before(:context) do
      prepare_synchronizer_folders
      create_taric_file example_date
      create_chief_file example_date
    end

    after(:context) do
      purge_synchronizer_folders
    end

    context "when everything is fine" do
      it "applies missing updates" do
        described_class.apply
        expect(taric_update.reload).to be_applied
        expect(chief_update.reload).to be_applied
      end
    end

    context 'when chief fails' do
      before do
        expect_any_instance_of(
          ChiefImporter
        ).to receive(:import).and_raise(
          ChiefImporter::ImportException
        )
      end

      it 'marks chief update as failed' do
        expect(taric_update).to be_pending
        expect(chief_update).to be_pending
        rescuing { described_class.apply }
        expect(taric_update.reload).to be_applied
        expect(chief_update.reload).to be_failed
      end
    end

    context 'when taric fails' do
      before do
        expect_any_instance_of(TaricImporter).to receive(
          :import
        ).and_raise TaricImporter::ImportException
      end

      it 'marks taric update as failed' do
        expect(taric_update).to be_pending
        expect(chief_update).to be_pending
        rescuing { described_class.apply }
        expect(taric_update.reload).to be_failed
        expect(chief_update.reload).to be_pending
      end
    end

    context 'but elasticsearch is buggy' do
      before do
        expect_any_instance_of(TaricImporter::Transaction).to receive(
          :persist
        ).and_raise Elasticsearch::Transport::Transport::SnifferTimeoutError
      end

      it 'stops syncing' do
        expect { described_class.apply }.to raise_error Sequel::Rollback
        expect(taric_update.reload).not_to be_applied
        expect(chief_update.reload).not_to be_applied
      end
    end

    context 'but we have a timeout' do
      before do
        expect_any_instance_of(
          TaricImporter::Transaction
        ).to receive(
          :persist
        ).and_raise Timeout::Error
      end

      it 'stops syncing' do
        expect { described_class.apply }.to raise_error Sequel::Rollback
        expect(taric_update.reload).not_to be_applied
        expect(chief_update.reload).not_to be_applied
      end
    end
  end

  describe '.rollback' do
    let!(:measure) { create :measure, operation_date: Date.current }
    let!(:update)  { create :chief_update, :applied, issue_date: Date.current }
    let!(:mfcm)    { create :mfcm, origin: update.filename }

    context 'successful run' do
      before {
        described_class.rollback(Date.yesterday, true)
      }

      it 'removes entries from oplog tables' do
        expect(Measure).to be_none
      end

      it 'marks Chief and Taric updates as pending' do
        expect(update.reload).to be_pending
      end

      it 'removes imported Chief records entries' do
        expect(Chief::Mfcm).to be_none
      end
    end

    context 'encounters an exception' do
      before {
        expect(Measure).to receive(:operation_klass).and_raise(StandardError)

        rescuing { described_class.rollback(Date.yesterday, true) }
      }

      it 'does not remove entries from oplog derived tables' do
        expect(Measure).to be_any
      end

      it 'leaves Chief and Taric updates in applid state' do
        expect(update.reload).to be_applied
      end

      it 'removes imported Chief records entries' do
        expect(Chief::Mfcm).to be_any
      end
    end

    context 'forced to redownload by default' do
      before {
        described_class.rollback(Date.yesterday)
      }

      it 'removes entries from oplog derived tables' do
        expect(Measure).to be_none
      end

      it 'deletes Chief and Taric updates' do
        expect { update.reload }.to raise_error Sequel::Error
      end

      it 'removes imported Chief records entries' do
        expect(Chief::Mfcm).to be_none
      end
    end

    context 'with date passed as string' do
      let!(:older_update) {
        create :taric_update, :applied, issue_date: 2.days.ago
      }

      before {
        described_class.rollback(Date.yesterday)
      }

      it 'removes entries from oplog derived tables' do
        expect(Measure).to be_none
      end

      it 'deletes Chief and Taric updates' do
        expect { update.reload }.to raise_error Sequel::Error
      end

      it 'removes imported Chief records entries' do
        expect(Chief::Mfcm).to be_none
      end

      it 'does not remove earlier updates (casts date as string to date)' do
        expect { older_update.reload }.not_to raise_error
      end
    end
  end

  def example_date
    @example_date ||= Date.current
  end
end
