require 'spec_helper'

describe QuotaDefinition do
  describe '#status' do
    context 'quota events present' do
    end

    context 'quota events absent' do
      it 'returns Open if quota definition is not in critical state' do
        quota_definition = build :quota_definition, critical_state: 'N'
        quota_definition.status.should == 'Open'
      end

      it 'returns Critical if quota definition is in critical state' do
        quota_definition = build :quota_definition, critical_state: 'Y'
        quota_definition.status.should == 'Critical'
      end
    end
  end
end
