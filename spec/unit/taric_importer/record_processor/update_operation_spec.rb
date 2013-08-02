require 'spec_helper'

describe TaricImporter::RecordProcessor::UpdateOperation do
  describe '#to_oplog_operation' do
    let(:empty_operation) {
      TaricImporter::RecordProcessor::UpdateOperation.new(nil, nil)
    }

    it 'identifies as update operation' do
      expect(empty_operation.to_oplog_operation).to eq :update
    end
  end
end
