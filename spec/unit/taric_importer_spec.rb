require "rails_helper"
require "taric_importer"

describe TaricImporter do
  describe "#import" do
    context "when provided with valid taric file" do
      it 'instantiates appropriate processing strategy' do
        allow_any_instance_of(
          TaricImporter::RecordProcessor
        ).to receive(:process!)
        path = "spec/fixtures/taric_samples/footnote.xml"
        importer = TaricImporter.new(path)
        importer.import(validate: false)
      end
    end

    context "on parsing error" do
      let(:broken_insert_record) { "spec/fixtures/taric_samples/broken_insert_record.xml" }

      it 'raises TaricImportException' do
        importer = TaricImporter.new(broken_insert_record)
        expect { importer.import }.to raise_error TaricImporter::ImportException
      end
    end
  end
end
