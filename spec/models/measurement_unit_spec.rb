require 'spec_helper'

describe MeasurementUnit do
  let(:measurement_unit) { create :measurement_unit, :with_description }

  describe '#to_s' do
    it 'is an alias for description' do
      measurement_unit.to_s.should eq measurement_unit.description
    end
  end
end
