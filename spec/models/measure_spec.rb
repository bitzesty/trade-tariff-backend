require 'spec_helper'

describe Measure do
  describe '#origin' do
    before(:all) { Measure.unrestrict_primary_key }

    it 'should be uk' do
      Measure.new(measure_sid: -1).origin.should == "uk"
    end
    it 'should be eu' do
      Measure.new(measure_sid: 1).origin.should == "eu"
    end
  end

  describe "#measure_generating_regulation_id" do
    it 'reads measure generating regulation id from database' do
      measure = create :measure
      measure.measure_generating_regulation_id.should_not be_blank
      measure.measure_generating_regulation_id.should == Measure.first.measure_generating_regulation_id
    end

    it 'measure D9500019 is globally replaced with D9601421' do
      measure = create :measure, measure_generating_regulation_id: "D9500019"
      measure.measure_generating_regulation_id.should_not be_blank
      measure.measure_generating_regulation_id.should == "D9601421"
    end
  end
end
