require 'spec_helper'

describe Sequel::Plugins::TariffValidationHelpers do
  describe 'validates_start_date' do 
    let!(:language) do 
      Language.unrestrict_primary_key
      Language.new language_id: "XX"
    end
    it 'checks that if validity_start_date is greater than validity_end_date then it is not valid' do
      language.validity_start_date = Date.today.ago(1.year)
      language.validity_end_date   = Date.today.ago(2.years)
      language.valid?.should be_false
    end
    it 'checks that validity_start_date is equal to validity_end_date is valid' do
      language.validity_start_date = Date.today.ago(1.year)
      language.validity_end_date   = Date.today.ago(1.year)
      language.valid?.should be_true
    end

    it 'checks that validity_start_date less than validity_end_date is valid' do
      language.validity_start_date = Date.today.ago(2.years)
      language.validity_end_date   = Date.today.ago(1.year)
      language.valid?.should be_true
    end

    it 'allows a blank end date' do
      language.validity_start_date = Date.today.ago(2.years)
      language.valid?.should be_true
    end 
  end
end
