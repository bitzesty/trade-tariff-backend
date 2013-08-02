require 'spec_helper'

describe TaricImporter::RecordProcessor::Record do
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

  describe 'initialization' do
    let(:record) {
      TaricImporter::RecordProcessor::Record.new(record_hash)
    }

    it 'assigns transaction id' do
      expect(record.transaction_id).to eq '31946'
    end

    it 'assigns model class' do
      expect(record.klass).to eq LanguageDescription
    end

    it 'assigns primary key as string array' do
      expect(record.primary_key).to eq Array(LanguageDescription.primary_key).map(&:to_s)
    end

    it 'assigns sanitized attributes' do
      expect(record.attributes).to eq({"language_code_id"=>"FR", "language_id"=>"EN", "description"=>"French"})
    end
  end

  describe '#attributes=' do
    let(:record) {
      TaricImporter::RecordProcessor::Record.new(record_hash)
    }

    context 'no mutations' do
      it 'assigns attributes unmutated' do
        record.attributes = { 'foo' => 'bar' }

        expect(record.attributes).to eq({"language_code_id"=>nil, "language_id"=>nil, "description"=>nil, "foo"=>"bar"})
      end
    end

    context 'mutated attributes' do
      before {
        class MockMutator
          def self.mutate(attributes)
            attributes['foo_id'] = attributes.delete('foo')
            attributes
          end
        end

        stub_const(
          "TaricImporter::RecordProcessor::LanguageDescriptionAttributeMutator",
          MockMutator
        )
      }

      it 'assigns mutated attributes' do
        record.attributes = { 'foo' => 'bar' }

        expect(record.attributes).to eq({"language_code_id"=>nil, "language_id"=>nil, "description"=>nil, "foo_id"=>"bar"})
      end
    end
  end
end
