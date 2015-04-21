require 'rails_helper'

describe TaricImporter::RecordProcessor::UpdateOperation do
  let(:record_hash) {
    {"transaction.id"=>"31946",
     "record.code"=>"130",
     "subrecord.code"=>"05",
     "record.sequence.number"=>"1",
     "update.type"=>"1",
     "language.description"=>
      {"language.code.id"=>"FR",
       "language.id"=>"EN",
       "description"=>"French!"}}
  }

  describe '#call' do
    let(:operation_date) { Date.new(2013,8,1) }
    let(:record) {
      TaricImporter::RecordProcessor::Record.new(record_hash)
    }

    let(:operation) {
      TaricImporter::RecordProcessor::UpdateOperation.new(record, operation_date)
    }

    context 'record for update present' do
      before {
        create :language_description, language_code_id: 'FR',
                                      language_id: 'EN',
                                      description: 'French'

        LanguageDescription.unrestrict_primary_key
      }

      it 'identifies as create operation' do
        operation.call

        expect(LanguageDescription.count).to eq 1
        expect(LanguageDescription.first.description).to eq 'French!'
      end

      it 'returns model instance' do
        expect(operation.call).to be_kind_of LanguageDescription
      end

      it 'sets update operation date to operation_date' do
        operation.call

        expect(
          LanguageDescription::Operation.where(operation: 'U').first.operation_date
        ).to eq operation_date
      end
    end

    context 'record for update missing' do
      it 'raises Sequel::RecordNotFound exception' do
        expect { operation.call }.to raise_error(Sequel::RecordNotFound)
      end
    end
  end
end
