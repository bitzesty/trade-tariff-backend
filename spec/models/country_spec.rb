require 'spec_helper'

describe Country do
  # fields
  it { should have_fields(:name, :iso_code) }

  # associations
  it { should have_and_belong_to_many :country_groups }
  it { should have_and_belong_to_many :measure_exclusions }
  it { should have_many :measures }

  # misc
  it { should be_timestamped_document }

  describe "#class_name" do # for common interface with CountryGroup
    it 'returns the class name' do
      subject.class_name.should == 'Country'
    end
  end

  describe "#to_s" do
    it 'returns description' do
      subject.to_s.should == subject.description
    end
  end
end
