require 'spec_helper'

describe Section do
  # fields
  it { should have_fields(:title, :numeral, :position) }

  # associations
  it { should have_many :chapters }
  it { should belong_to :nomenclature }
end
