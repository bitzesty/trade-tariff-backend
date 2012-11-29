require 'spec_helper'

require 'tariff_importer' # require it so that ActiveSupport requires get executed
require 'tariff_importer/importers/taric_importer'
require 'tariff_importer/importers/taric_importer/strategies/base_strategy'
require 'tariff_importer/importers/taric_importer/strategies/strategies'

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
        TaricImporter::Strategies::Footnote.any_instance.expects(:process!)

        @importer = TaricImporter.new(valid_file)
        @importer.import
      end
    end

    context "parsing insert operation" do
      let(:insert_record) { "spec/fixtures/taric_samples/insert_record.xml" }

      it 'processes inserts' do
        # insert_record.xml is inserting to ExplicitAbrogationRegulation

        db_stub, model_stub = stub(), stub()
        ExplicitAbrogationRegulation.expects(:model).returns(model_stub)
        model_stub.expects(:insert).returns(true)

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
        update_stub = stub()
        ExplicitAbrogationRegulation.expects(:filter).returns(update_stub)
        update_stub.expects(:update).with(expected_attributes).returns(true)

        @importer = TaricImporter.new(update_record)
        @importer.import
      end
    end

    context "parsing delete operation" do
      let(:delete_record) { "spec/fixtures/taric_samples/delete_record.xml" }

      it 'processes deletions' do
        # update_record.xml is inserting to ExplicitAbrogationRegulation

        destroy_stub = stub()
        ExplicitAbrogationRegulation.expects(:filter).with({:explicit_abrogation_regulation_id=>"D1202470", :explicit_abrogation_regulation_role=>"7"}).returns(destroy_stub)
        destroy_stub.expects(:delete).returns(true)

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
