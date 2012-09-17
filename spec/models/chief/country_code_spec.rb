require 'spec_helper'

describe Chief::CountryCode do
  describe '.to_taric' do
    let!(:country_code) { create :country_code}
    let(:example_code) { Forgery(:basic).text }

    it 'maps CHIEF code to Taric' do
      Chief::CountryCode.to_taric(country_code.chief_country_cd).should == country_code.country_cd
    end

    it 'returns same CHIEF code if mapping is not found' do
      Chief::CountryCode.to_taric(example_code).should == example_code
    end
  end
end
