require 'rails_helper'

describe Change do
  let!(:measure) { create :measure }
  let(:change)   {
    Change.new(
      model: 'Measure',
      oid: measure.source.oid,
      operation_date: measure.source.operation_date,
      operation: measure.operation
    )
  }

  describe '#operation_record' do
    it 'returns relevant models operation record' do
      expect(change.operation_record).to eq measure.source
    end
  end

  describe '#record' do
    it 'returns model associated with change operation' do
      expect(change.record.pk).to eq measure.pk
    end
  end
end
