require 'spec_helper'

describe QuotaEvent do
  let!(:quota_definition) { create :quota_definition }
  let!(:balance_event)    { create :quota_balance_event, quota_definition: quota_definition,
                                                         occurrence_timestamp: 3.days.ago }
  let!(:exhaustion_event) { create :quota_exhaustion_event, quota_definition: quota_definition,
                                                            occurrence_timestamp: 1.day.ago }
  let!(:critical_event)   { create :quota_critical_event }

  describe '.for_quota_definition' do
    it 'returns all quota events for specified quota_definition_sid' do
      events = QuotaEvent.for_quota_definition(quota_definition.quota_definition_sid).all
      events.select{|ev| ev[:event_type] == "balance" }.should_not be_blank
      events.select{|ev| ev[:event_type] == "exhaustion" }.should_not be_blank
      events.select{|ev| ev[:event_type] == "critical" }.should be_blank
    end
  end

  describe '.last_for' do
    it 'returns last quota event type (as class) for provided quota_definition_sid value' do
      QuotaEvent.last_for(quota_definition.quota_definition_sid).should == QuotaExhaustionEvent
    end
  end
end
