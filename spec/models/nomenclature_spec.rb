require 'spec_helper'

describe Nomenclature do
  # fields
  it { should have_fields(:as_of_date) }

  # associations
  it { should have_many :sections }
  it { should have_many :chapters }
  it { should have_many :headings }
  it { should have_many :commodities }
end
