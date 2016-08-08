require "rails_helper"
require "chief_importer"

describe ChiefImporter do
  describe "#import" do
    let(:chief_update) { create :chief_update, example_date: Date.new(2012,2,13)}

    context "when provided with valid chief file" do

      before do
        allow(chief_update).to receive(:file_path)
          .and_return("spec/fixtures/chief_samples/KBT009(12044).txt")
      end

      it "assigns start entry" do
        importer = ChiefImporter.new(chief_update)
        importer.import
        expect(importer.start_entry).to be_kind_of ChiefImporter::StartEntry
      end

      it "assigns end entry" do
        importer = ChiefImporter.new(chief_update)
        importer.import
        expect(importer.end_entry).to be_kind_of ChiefImporter::EndEntry
      end

      it "logs an info event" do
        tariff_importer_logger do
          importer = ChiefImporter.new(chief_update)
          importer.import
          expect(@logger.logged(:info).last).to eq("Parsed 1506 CHIEF records from 2012-02-13_KBT009(12044).txt")
        end
      end
    end

    context "when provided with invalid chief file" do
      before do
        allow(chief_update).to receive(:file_path)
          .and_return("spec/fixtures/chief_samples/invalid_sample.txt")
      end

      it "does not assign start entry" do
        importer = ChiefImporter.new(chief_update)
        importer.import
        expect(importer.start_entry).to be_blank
      end

      it "does not assign end entry" do
        importer = ChiefImporter.new(chief_update)
        importer.import
        expect(importer.end_entry).to be_blank
      end
    end

    context "when provided with malformed sample" do
      before do
        allow(chief_update).to receive(:file_path)
          .and_return("spec/fixtures/chief_samples/malformed_sample.txt")
      end

      it "raises ChiefImportException and sends a log" do
        tariff_importer_logger do
          importer = ChiefImporter.new(chief_update)
          expect { importer.import }.to raise_error ChiefImporter::ImportException
          expect(@logger.logged(:error).last).to eq("CHIEF import of 2012-02-13_KBT009(12044).txt failed: Reason: Unclosed quoted field on line 1.")
        end
      end
    end
  end
end
