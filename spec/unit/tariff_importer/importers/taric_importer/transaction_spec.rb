require 'spec_helper'
require 'tariff_importer/importers/taric_importer/transaction'

describe TaricImporter::Transaction do
  let(:record) {
    {"transaction"=>
      {"id"=>"1",
       "app.message"=>
        {"id"=>"8",
         "transmission"=>
          {"record"=>
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"3",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN",
               "description"=>"French"}}}}}}
  }
  let(:transaction_date) { Date.today }

  describe 'initialization' do
    context 'invalid record structure provided' do
      it 'raises an ArgumentError exception' do
        expect { described_class.new({}) }.to raise_error ArgumentError
      end
    end
  end

  describe '#persist' do
    let(:record_processor) { stub(process!: true) }
    let(:record_processor_klass) { stub(new: record_processor) }

    subject { described_class.new(record, transaction_date) }

    before { subject.persist(record_processor_klass) }

    it 'instantiates record processor class' do
      record_processor_klass.should have_received(:new)
    end

    it 'invokes relevant record processor' do
      record_processor.should have_received(:process!)
    end
  end

  describe '#validate' do
    subject { described_class.new(record, transaction_date) }

    before { subject.stub(:record_stack).and_return([entry]) }

    context 'all records are valid' do
      let(:entry)            { stub(validate!: true) }

      it 'does not raise an exception' do
        expect { subject.validate }.not_to raise_error
      end
    end

    context 'invalid records present' do
      let(:entry)            { stub }

      before {
        entry.should_receive(:validate!).and_raise(Sequel::ValidationFailed.new('ValidationError'))
      }

      it 'raises ValidationFailed exception ending import' do
        expect { subject.validate }.to raise_error Sequel::ValidationFailed
      end
    end
  end
end
