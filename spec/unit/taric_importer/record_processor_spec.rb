require 'spec_helper'

require 'taric_importer'
require 'taric_importer/record_processor'
require 'taric_importer/record_processor/create_operation'

describe TaricImporter::RecordProcessor do
  let(:record_hash) {
    {"transaction.id"=>"31946",
     "record.code"=>"130",
     "subrecord.code"=>"05",
     "record.sequence.number"=>"1",
     "update.type"=>"3",
     "language.description"=>
      {"language.code.id"=>"FR",
       "language.id"=>"EN",
       "description"=>"French"}}
  }

  let(:record_processor) {
    TaricImporter::RecordProcessor.new(record_hash, Date.new(2013,8,1))
  }

  describe '#record=' do
    it 'instantiates a Record' do
      record_processor.record = record_hash

      expect(record_processor.record).to be_kind_of TaricImporter::RecordProcessor::Record
    end
  end

  describe '#operation_class=' do
    context 'with update identifier' do
      before { record_processor.operation_class = "1" }

      it 'assigns UpdateOperation' do
        expect(record_processor.operation_class).to eq TaricImporter::RecordProcessor::UpdateOperation
      end
    end

    context 'with destroy identifier' do
      before { record_processor.operation_class = "2" }

      it 'assigns DestroyOperation' do
        expect(record_processor.operation_class).to eq TaricImporter::RecordProcessor::DestroyOperation
      end
    end

    context 'with create identifier' do
      before { record_processor.operation_class = "3" }

      it 'assigns CreateOperation' do
        expect(record_processor.operation_class).to eq TaricImporter::RecordProcessor::CreateOperation
      end
    end

    context 'unknown operation' do
      it 'raises TaricImporter::UnknownOperation exception' do
        expect { record_processor.operation_class = "error" }.to raise_error TaricImporter::UnknownOperationError
      end
    end
  end

  describe '#process!' do
    context 'with default processor' do
      let(:fake_create_operation_class)   { double('CreateOperation', new: fake_operation_instance) }
      let(:fake_operation_instance) { double('instance of CreateOperation', call: true) }

      before {
        stub_const(
          "TaricImporter::RecordProcessor::OPERATION_MAP",
          { "3" => fake_create_operation_class }
        )
      }

      it 'performs default create operation' do
        record_processor = TaricImporter::RecordProcessor.new(record_hash, Date.new(2013,8,1))
        record_processor.process!

        expect(fake_create_operation_class).to have_received :new
        expect(fake_operation_instance).to     have_received :call
      end
    end

    context 'with custom processor' do
      let(:fake_create_operation_class)   { double('LanguageDescriptionCreateOperation', new: fake_operation_instance) }
      let(:fake_operation_instance) { double('instance of LanguageDescriptionCreateOperation', call: true) }

      before {
        stub_const(
          "TaricImporter::RecordProcessor::LanguageDescriptionCreateOperation",
          fake_create_operation_class
        )
      }

      it 'performs model type specific create operation' do
        record_processor = TaricImporter::RecordProcessor.new(record_hash, Date.new(2013,8,1))
        record_processor.process!

        expect(fake_create_operation_class).to have_received :new
        expect(fake_operation_instance).to     have_received :call
      end
    end
  end
end
