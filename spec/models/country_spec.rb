require 'spec_helper'

describe Country do
  # fields
  it { should have_fields(:name, :iso_code) }

  # associations
  it { should have_and_belong_to_many :country_groups }
end
