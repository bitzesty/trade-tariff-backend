require 'spec_helper'

require 'tariff_importer' # require it so that ActiveSupport requires get executed
require 'tariff_importer/importers/chief_importer'

describe ChiefImporter do
  let(:path)       { Forgery(:basic).text }

  describe 'initialization' do
    it 'assigns path' do
      importer = ChiefImporter.new(path)
      importer.path.to_s.should == path
    end
  end

  describe "#import" do

    context "when provided with valid chief file" do
      let(:valid_file) { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }

      before(:all) do
        @importer = ChiefImporter.new(valid_file)
        @importer.import
      end

      it 'assigns start entry' do
        @importer.start_entry.should be_kind_of ChiefImporter::StartEntry
      end

      it 'assigns end entry' do
        @importer.end_entry.should be_kind_of ChiefImporter::EndEntry
      end
    end

    context "when provided with invalid chief file" do
      let(:invalid_file) { "spec/fixtures/chief_samples/invalid_sample.txt" }

      before(:all) do
        @importer = ChiefImporter.new(invalid_file)
        rescuing { @importer.import }
      end

      it 'does not assign start entry' do
        @importer.start_entry.should be_blank
      end

      it 'does not assign end entry' do
        @importer.end_entry.should be_blank
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
