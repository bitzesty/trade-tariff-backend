require 'spec_helper'

describe Language do
  describe 'valid' do
    before :all do
      Language.unrestrict_primary_key
    end
    it 'LA1' do
      Language.create(language_id: "XX", 
        validity_start_date: Date.today)
      la = Language.new(language_id: "XX", 
        validity_start_date: Date.today)
      la.valid?.should be_false
    end
    it 'LA3' do
      la = Language.new(language_id: "YY", 
        validity_start_date: Date.today + 2.days, 
        validity_end_date: Date.today)
      la.valid?.should be_false
    end
  end
end
