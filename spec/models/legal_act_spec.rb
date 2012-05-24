require 'spec_helper'

describe LegalAct do
  # fields
  it { should have_fields(:code, :url) }

  # associations
  it { should have_many :measures }

  # misc
  it { should be_timestamped_document }
end
