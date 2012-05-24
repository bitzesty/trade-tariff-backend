require 'spec_helper'

describe Measure do
  # fields
  it { should have_fields(:origin, :measure_type, :duty_rates) }

  # associations
  it { should have_and_belong_to_many :footnotes }
  it { should have_and_belong_to_many :conditions }
  it { should have_and_belong_to_many :additional_codes }
  it { should have_and_belong_to_many :excluded_countries }
  it { should belong_to :measurable }
  it { should belong_to :region }

  # misc
  it { should be_timestamped_document }
end
