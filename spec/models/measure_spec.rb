require 'spec_helper'

describe Measure do
  # fields
  it { should have_fields(:origin, :measure_type, :duty_rates) }

  # associations
  it { should have_and_belong_to_many :footnotes }
  it { should have_and_belong_to_many :additional_codes }
  it { should have_and_belong_to_many :excluded_countries }
  it { should belong_to :measurable }
  it { should belong_to :region }
  it { should embed_many :conditions }

  # misc
  it { should be_timestamped_document }

  describe "#ergo_omnes?" do
    let(:measure_with_region)    { create :measure, :with_region }
    let(:measure_without_region) { create :measure }

    it 'measure is applicable for all if it has no region associated' do
      measure_with_region.ergo_omnes?.should == false
      measure_without_region.ergo_omnes?.should == true
    end
  end
end
