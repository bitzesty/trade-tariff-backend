require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::ChiefUpdate do
  it_behaves_like 'Base Update'

  let(:example_date) { Date.new(2010,1,1) }
  let(:chief_file) { ChiefFileNameGenerator.new(example_date) }

  describe '.download' do
    it "Calls TariffDownloader perform for a CHIEF update" do
      downlader = instance_double("TariffSynchronizer::TariffDownloader", perform: true)
      expect(TariffSynchronizer::TariffDownloader).to receive(:new)
        .with(chief_file.name, chief_file.url, example_date, TariffSynchronizer::ChiefUpdate)
        .and_return(downlader)
      TariffSynchronizer::ChiefUpdate.download(example_date)
    end
  end

  describe '.sync' do
    let(:not_found_response) { build :response, :not_found }

    context 'file not found for nth time in a row' do
      let!(:chief_update1) { create :chief_update, :missing, issue_date: Date.today.ago(2.days) }
      let!(:chief_update2) { create :chief_update, :missing, issue_date: Date.today.ago(3.days) }
      let!(:stub_logger)   { double.as_null_object }

      before do
        allow(TariffSynchronizer::TariffDownloader).to receive(:download_content)
                                                       .and_return(not_found_response)
      end

      it 'notifies about several missing updates in a row' do
        expect(TariffSynchronizer::ChiefUpdate).to receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::ChiefUpdate.sync
      end
    end
  end

  describe "#apply", truncation: true do
    let(:example_date) { Forgery(:date).date }
    let!(:example_chief_update) { create :chief_update, example_date: example_date }

    before do
      prepare_synchronizer_folders
      create_chief_file example_date
    end

    it 'sets applied_at' do
      TariffSynchronizer::ChiefUpdate.first.apply
      expect(example_chief_update.reload.applied_at).to_not be_nil
    end

    it 'executes importer' do
      mock_importer = double
      expect(mock_importer).to receive(:import).and_return(true)
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      TariffSynchronizer::ChiefUpdate.first.apply
    end

    it 'logs an info event' do
      tariff_synchronizer_logger_listener
      TariffSynchronizer::ChiefUpdate.first.apply
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Applied CHIEF update/
    end

    it 'updates file entry state to processed' do
      mock_importer = double('importer').as_null_object
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 1
      TariffSynchronizer::ChiefUpdate.first.apply
      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.applied.count).to eq 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = double
      expect(mock_importer).to receive(:import).and_raise(ChiefImporter::ImportException)
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 1
      rescuing { TariffSynchronizer::ChiefUpdate.first.apply }
      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.applied.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.failed.count).to eq 1
    end

    after  { purge_synchronizer_folders }
  end

  describe '.rebuild' do
    before {
      prepare_synchronizer_folders
      create_chief_file example_date
    }

    context 'entry for the day/update does not exist yet' do
      it 'creates db record from available file name' do
        expect(TariffSynchronizer::BaseUpdate.count).to eq 0

        TariffSynchronizer::ChiefUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
        first_update = TariffSynchronizer::BaseUpdate.first
        expect(first_update.issue_date).to eq example_date
      end
    end

    context 'entry for the day/update exists already' do
      let!(:example_chief_update) { create :chief_update, example_date: example_date }

      it 'does not create db record if it is already available for the day/update type combo' do
        expect(TariffSynchronizer::BaseUpdate.count).to eq 1

        TariffSynchronizer::ChiefUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
      end
    end

    after  { purge_synchronizer_folders }
  end
end
