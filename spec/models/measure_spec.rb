require 'spec_helper'

describe Measure do
  describe 'orign' do
    before :all do
      Measure.unrestrict_primary_key
    end
    it 'should be uk' do
      Measure.new(measure_sid: -1).origin.should == "uk"
    end
    it 'should be eu' do
      Measure.new(measure_sid: 1).origin.should == "eu"
    end
  end
end
