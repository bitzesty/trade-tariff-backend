require 'spec_helper'

describe CountryGroup do
  # fields
  it { should have_fields(:description, :area_id, :sigl) }

  # associations
  it { should have_and_belong_to_many :countries }
  it { should have_many :measures }

  # misc
  it { should be_timestamped_document }

  describe "#class_name" do # for common interface with Country
    it 'returns the class name' do
      subject.class_name.should == 'CountryGroup'
    end
  end

  describe "#to_s" do
    it 'returns description' do
      subject.to_s.should == subject.description
    end
  end
end
