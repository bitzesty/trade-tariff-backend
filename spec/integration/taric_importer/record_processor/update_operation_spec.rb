require 'rails_helper'

describe TaricImporter::RecordProcessor::UpdateOperation do
  let(:record_hash) {
    {"transaction_id"=>"31946",
     "record_code"=>"130",
     "subrecord_code"=>"05",
     "record_sequence_number"=>"1",
     "update_type"=>"1",
     "language_description"=>
      {"language_code_id"=>"FR",
       "language_id"=>"EN",
       "description"=>"French!"}}
  }

  describe '#call' do
    let(:operation_date) { Date.new(2013,8,1) }
    let(:record) { TaricImporter::RecordProcessor::Record.new(record_hash) }

    context 'record for update present' do
      before { LanguageDescription.unrestrict_primary_key }

      it 'identifies as create operation' do
        create_language_description_record
        build_update_operation.call
        expect(LanguageDescription.count).to eq 1
        expect(LanguageDescription.first.description).to eq 'French!'
      end

      it 'returns model instance' do
        create_language_description_record
        expect(build_update_operation.call).to be_kind_of LanguageDescription
      end

      it 'returns model instance even when the previous record is equal' do
        create_language_description_record
        build_update_operation.call
        expect(build_update_operation.call).to be_kind_of LanguageDescription
      end

      it 'sets update operation date to operation_date' do
        create_language_description_record
        build_update_operation.call
        expect(
          LanguageDescription::Operation.where(operation: 'U').first.operation_date
        ).to eq operation_date
      end
    end

    context 'record for update missing' do
      it 'raises Sequel::RecordNotFound exception' do
        expect { build_update_operation.call }.to raise_error(Sequel::RecordNotFound)
      end
    end


    def build_update_operation
      TaricImporter::RecordProcessor::UpdateOperation.new(record, operation_date)
    end

    def create_language_description_record
      create :language_description, language_code_id: 'FR', language_id: 'EN', description: 'French'
    end
  end
end
