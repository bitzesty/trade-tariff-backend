require 'spec_helper'

describe CountryGroup do
  # fields
  it { should have_fields(:description, :area_id, :sigl) }

  # associations
  it { should have_and_belong_to_many :countries }
  it { should have_many :measures }

  # misc
  it { should be_timestamped_document }
end
