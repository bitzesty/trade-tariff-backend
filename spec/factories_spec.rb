require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "#{factory_name} factory" do
    let(:factory) { build factory_name }
    it 'should be valid' do
      expect(factory).to be_valid
    end
  end
end
