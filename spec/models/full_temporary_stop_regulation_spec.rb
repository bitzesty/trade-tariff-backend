require 'spec_helper'

describe FullTemporaryStopRegulation do
  let(:fts_regulation) { build :fts_regulation, effective_enddate: Date.today }

  describe '#regulation_id' do
    it 'is an alias for full temporary stop regulation id' do
      fts_regulation.regulation_id.should == fts_regulation.full_temporary_stop_regulation_id
    end
  end

  describe '#effective_end_date' do
    it 'is an alias for effective_enddate' do
      fts_regulation.effective_end_date.should == fts_regulation.effective_enddate.to_date
    end
  end

  describe '#effective_start_date' do
    it 'is an alias for validity_start_date' do
      fts_regulation.effective_start_date.should == fts_regulation.validity_start_date.to_date
    end
  end
end
