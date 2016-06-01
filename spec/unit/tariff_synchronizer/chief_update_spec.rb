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
        allow(TariffSynchronizer::TariffUpdatesRequester).to receive(:perform)
                                                       .and_return(not_found_response)
      end

      it 'notifies about several missing updates in a row' do
        expect(TariffSynchronizer::ChiefUpdate).to receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::ChiefUpdate.sync
      end
    end
  end

  describe "#import!" do

    let(:chief_update) { create :chief_update}

    before do
      # stub the file_path method to return a valid path of a real file.
      allow(chief_update).to receive(:file_path)
                              .and_return("spec/fixtures/chief_samples/KBT009(12044).txt")

    end

    it "Calls the ChiefImporter import method and send instance as argument" do
      chief_importer = instance_double("ChiefImporter")
      expect(ChiefImporter).to receive(:new).with(chief_update)
                                                  .and_return(chief_importer)
      expect(chief_importer).to receive(:import)
      chief_update.import!
    end

    it "Mark the Chief update as applied" do
      allow_any_instance_of(ChiefImporter).to receive(:import)
      chief_update.import!
      expect(chief_update.reload).to be_applied
    end

    it "logs an info event" do
      tariff_synchronizer_logger_listener
      allow_any_instance_of(ChiefImporter).to receive(:import)
      chief_update.import!
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Applied CHIEF update/
    end

    it "ChiefTransformer is called" do
      chief_transformer = instance_double("ChiefTransformer")
      expect(ChiefTransformer).to receive(:instance).and_return(chief_transformer)
      expect(chief_transformer).to receive(:invoke)
      allow_any_instance_of(ChiefImporter).to receive(:import)
      chief_update.import!
    end
  end
end
