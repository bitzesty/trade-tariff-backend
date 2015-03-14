require 'rails_helper'

require 'taric_importer/transaction'

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
    let(:record_processor) { double(process!: true).as_null_object }
    let(:record_processor_klass) { double(new: record_processor).as_null_object }

    subject { described_class.new(record, transaction_date) }

    before { subject.persist(record_processor_klass) }

    it 'instantiates record processor class' do
      expect(record_processor_klass).to have_received(:new)
    end

    it 'invokes relevant record processor' do
      expect(record_processor).to have_received(:process!)
    end
  end
end
