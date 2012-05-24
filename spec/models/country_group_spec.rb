require 'spec_helper'

describe CountryGroup do
  # fields
  it { should have_fields(:code, :description) }

  # associations
  it { should have_and_belong_to_many :countries }
end
