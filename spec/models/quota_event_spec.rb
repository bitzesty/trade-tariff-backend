require 'rails_helper'

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
      expect(
        events.select{|ev| ev[:event_type] == "balance" }
      ).to_not be_blank
      expect(
        events.select{|ev| ev[:event_type] == "exhaustion" }
      ).to_not be_blank
      expect(
        events.select{|ev| ev[:event_type] == "critical" }
      ).to be_blank
    end
  end

  describe '.last_for' do
    it 'returns last quota event type (as class) for provided quota_definition_sid value' do
      expect(
        QuotaEvent.last_for(quota_definition.quota_definition_sid)
      ).to eq QuotaExhaustionEvent
    end
  end
end
