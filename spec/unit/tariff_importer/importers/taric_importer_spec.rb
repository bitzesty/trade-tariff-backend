require 'spec_helper'

require 'tariff_importer' # require it so that ActiveSupport requires get executed
require 'tariff_importer/importers/taric_importer'

describe TaricImporter do
  let(:path)       { Forgery(:basic).text }

  describe 'initialization' do
    it 'assigns path' do
      importer = TaricImporter.new(path)
      importer.path.should == path
    end
  end

  describe "#import" do
    context "when provided with valid taric file" do
      let(:valid_file) { "spec/fixtures/taric_samples/footnote.xml" }

      it 'instantiates appropriate processing strategy' do
        TaricImporter::RecordProcessor.any_instance.expects(:process!)

        @importer = TaricImporter.new(valid_file)
        @importer.import
      end
    end

    context "parsing insert operation" do
      let(:insert_record) { "spec/fixtures/taric_samples/insert_record.xml" }

      it 'processes inserts' do
        # insert_record.xml is inserting to ExplicitAbrogationRegulation
        model_stub = stub(validate!: true, save: true)
        ExplicitAbrogationRegulation.expects(:new).returns(model_stub)

        @importer = TaricImporter.new(insert_record)
        @importer.import
      end
    end

    context "parsing update operation" do
      let(:update_record) { "spec/fixtures/taric_samples/update_record.xml" }
      let(:expected_attributes) {
        {
         explicit_abrogation_regulation_role: "7",
         explicit_abrogation_regulation_id: "D1202470",
         published_date: "2012-05-08",
         officialjournal_number: "L 121",
         officialjournal_page: "36",
         replacement_indicator: "0",
         abrogation_date: "2012-05-08",
         information_text: "DUMP (termination) - BY - Chap 73",
         approved_flag:"1"
        }
      }

      it 'processes updates' do
        # update_record.xml is updating to ExplicitAbrogationRegulation
        update_stub = stub(save: true, validate!: true, set: true, columns: [])
        dataset = stub(first: update_stub)
        ExplicitAbrogationRegulation.expects(:filter).returns(dataset)

        @importer = TaricImporter.new(update_record)
        @importer.import
      end
    end

    context "parsing delete operation" do
      let(:delete_record) { "spec/fixtures/taric_samples/delete_record.xml" }

      it 'processes deletions' do
        # update_record.xml is inserting to ExplicitAbrogationRegulation

        destroy_stub = stub()
        dataset_stub = stub(first: destroy_stub)
        ExplicitAbrogationRegulation.expects(:filter).returns(dataset_stub)
        destroy_stub.expects(:destroy).returns(true)

        @importer = TaricImporter.new(delete_record)
        @importer.import
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
end
