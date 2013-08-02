require 'spec_helper'

describe TaricImporter::RecordProcessor::DestroyOperation do
  describe '#to_oplog_operation' do
    let(:empty_operation) {
      TaricImporter::RecordProcessor::DestroyOperation.new(nil, nil)
    }

    it 'identifies as destroy operation' do
      expect(empty_operation.to_oplog_operation).to eq :destroy
    end
  end
end
