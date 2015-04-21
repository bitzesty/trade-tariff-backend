require 'rails_helper'

require 'chief_importer'

describe ChiefImporter do
  describe 'initialization' do
    it 'assigns path' do
      importer = ChiefImporter.new("spec/fixtures/chief_samples/KBT009\(12044\).txt")
      expect(importer.path.to_s).to eq "spec/fixtures/chief_samples/KBT009\(12044\).txt"
    end
  end

  describe "#import" do

    context "when provided with valid chief file" do
      before(:all) do
        valid_file = "spec/fixtures/chief_samples/KBT009\(12044\).txt"

        @importer = ChiefImporter.new(valid_file)
        @importer.import
      end

      it 'assigns start entry' do
        expect(@importer.start_entry).to be_kind_of ChiefImporter::StartEntry
      end

      it 'assigns end entry' do
        expect(@importer.end_entry).to be_kind_of ChiefImporter::EndEntry
      end
    end

    context "when provided with invalid chief file" do
      before(:all) do
        invalid_file = "spec/fixtures/chief_samples/invalid_sample.txt"

        @importer = ChiefImporter.new(invalid_file)
        rescuing { @importer.import }
      end

      it 'does not assign start entry' do
        expect(@importer.start_entry).to be_blank
      end

      it 'does not assign end entry' do
        expect(@importer.end_entry).to be_blank
      end
    end

    context "when provided with malformed sample" do
      let(:invalid_file) { "spec/fixtures/chief_samples/malformed_sample.txt" }

      it 'raises ChiefImportException' do
        @importer = ChiefImporter.new(invalid_file)
        expect { @importer.import }.to raise_error ChiefImporter::ImportException
      end
    end
  end
end
