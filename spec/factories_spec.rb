require "rails_helper"

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "#{factory_name} factory" do
    it "should be valid" do
      factory = build factory_name
      expect(factory).to be_valid if factory.respond_to?(:valid)
    end
  end
end
