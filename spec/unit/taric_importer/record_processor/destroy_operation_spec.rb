require 'rails_helper'

describe TaricImporter::RecordProcessor::DestroyOperation do
  let(:empty_operation) {
    TaricImporter::RecordProcessor::DestroyOperation.new(nil, nil)
  }

  describe '#to_oplog_operation' do
    it 'identifies as destroy operation' do
      expect(empty_operation.to_oplog_operation).to eq :destroy
    end
  end

  describe '#ignore_presence_on_destroy?' do
    it 'returns true if presence ignored' do
      allow(TariffSynchronizer).to receive(:ignore_presence_on_destroy).and_return(true)
      expect(empty_operation.send(:ignore_presence_on_destroy?)).to be_truthy
    end
  end
end
