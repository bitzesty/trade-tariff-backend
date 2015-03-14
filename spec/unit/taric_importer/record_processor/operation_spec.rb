require 'rails_helper'

describe TaricImporter::RecordProcessor::Operation do
  describe '#call' do
    let(:empty_operation) {
      TaricImporter::RecordProcessor::Operation.new(nil, nil)
    }

    it 'must be implemented by subclasses' do
      expect{ empty_operation.call }.to raise_error
    end
  end

  describe '#to_oplog_operation' do
    let(:empty_operation) {
      TaricImporter::RecordProcessor::Operation.new(nil, nil)
    }

    it 'must be implemented by subclasses' do
      expect{ empty_operation.to_oplog_operation }.to raise_error
    end
  end
end
