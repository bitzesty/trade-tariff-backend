require "rails_helper"
require "tariff_importer"

describe TariffImporter do
  let(:valid_path)       { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }
  let(:date)             { Date.new(2013, 8, 2) }

  describe "#initialize" do
    it "set path and issue_date attributes" do
      importer = TariffImporter.new(valid_path, date)
      expect(importer.path).to eq(valid_path)
      expect(importer.issue_date).to eq(date)
    end

    it "set issue_date as nil if not defined" do
      importer = TariffImporter.new(valid_path)
      expect(importer.issue_date).to be_nil
    end

    it "throws an error if path is non existent" do
      expect {
        TariffImporter.new("x")
      }.to raise_error(TariffImporter::FileNotFoundError)
    end
  end

  describe "#importer_logger" do
    it "triggers a call to the tariff importer logger" do
      expect(ActiveSupport::Notifications).to receive(:instrument)
                                              .with("chief_imported.tariff_importer", {:x=>"y"})
      TariffImporter.new(valid_path).importer_logger("chief_imported", x: "y")
    end
  end
end
