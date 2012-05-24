require 'spec_helper'

describe Footnote do
  # fields
  it { should have_fields(:code, :description) }

  # associations
  it { should have_and_belong_to_many :measures }

  # misc
  it { should be_timestamped_document }
end
