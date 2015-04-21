require 'rails_helper'

describe TaricImporter::RecordProcessor::CreateOperation do
  describe '#to_oplog_operation' do
    let(:empty_operation) {
      TaricImporter::RecordProcessor::CreateOperation.new(nil, nil)
    }

    it 'identifies as create operation' do
      expect(empty_operation.to_oplog_operation).to eq :create
    end
  end
end
