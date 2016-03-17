require "rails_helper"
require "tariff_importer"
require "chief_importer"

describe ChiefImporter do
  describe "initialization" do
    it "assigns path" do
      importer = ChiefImporter.new("spec/fixtures/chief_samples/KBT009\(12044\).txt")
      expect(importer.path.to_s).to eq "spec/fixtures/chief_samples/KBT009\(12044\).txt"
    end
  end

  describe "#import" do

    context "when provided with valid chief file" do
      let(:valid_file) { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }

      it "assigns start entry" do
        importer = ChiefImporter.new(valid_file)
        importer.import
        expect(importer.start_entry).to be_kind_of ChiefImporter::StartEntry
      end

      it "assigns end entry" do
        importer = ChiefImporter.new(valid_file)
        importer.import
        expect(importer.end_entry).to be_kind_of ChiefImporter::EndEntry
      end

      it "logs an info event" do
        tariff_importer_logger_listener
        importer = ChiefImporter.new(valid_file)
        importer.import
        expect(@logger.logged(:info).size).to eq 1
        expect(@logger.logged(:info).last).to match /Parsed (.*) CHIEF records/
      end
    end

    context "when provided with invalid chief file" do
      before(:all) do
        invalid_file = "spec/fixtures/chief_samples/invalid_sample.txt"

        @importer = ChiefImporter.new(invalid_file)
        rescuing { @importer.import }
      end

      it "does not assign start entry" do
        expect(@importer.start_entry).to be_blank
      end

      it "does not assign end entry" do
        expect(@importer.end_entry).to be_blank
      end
    end

    context "when provided with malformed sample" do
      let(:invalid_file) { "spec/fixtures/chief_samples/malformed_sample.txt" }

      it "raises ChiefImportException and sends a log" do
        tariff_importer_logger_listener
        @importer = ChiefImporter.new(invalid_file)
        expect { @importer.import }.to raise_error ChiefImporter::ImportException
        expect(@logger.logged(:error).size).to eq 1
        expect(@logger.logged(:error).last).to match /CHIEF import of (.*) failed/
      end
    end
  end
end
