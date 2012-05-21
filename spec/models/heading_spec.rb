require 'spec_helper'

describe Heading do
  # fields
  it { should have_fields(:code, :description, :hier_pos, :substring) }

  # associations
  it { should have_many :commodities }
  it { should belong_to :nomenclature }
  it { should belong_to :chapter }
end
