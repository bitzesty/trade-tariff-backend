require 'spec_helper'

require 'taric_importer'

describe TaricImporter do
  describe 'initialization' do
    it 'assigns path' do
      importer = TaricImporter.new("spec/fixtures/taric_samples/footnote.xml")
      importer.path.should == "spec/fixtures/taric_samples/footnote.xml"
    end
  end

  describe "#import" do
    context "when provided with valid taric file" do
      let(:valid_file) { "spec/fixtures/taric_samples/footnote.xml" }

      it 'instantiates appropriate processing strategy' do
        TaricImporter::RecordProcessor.any_instance.should_receive(:process!)

        @importer = TaricImporter.new(valid_file)
        @importer.import
      end
    end

    context "on parsing error" do
      let(:broken_insert_record) { "spec/fixtures/taric_samples/broken_insert_record.xml" }

      it 'raises TaricImportException' do
        @importer = TaricImporter.new(broken_insert_record)
        expect { @importer.import }.to raise_error TaricImporter::ImportException
      end
    end
  end
end
