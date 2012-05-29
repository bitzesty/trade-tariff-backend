require 'spec_helper'

describe Chapter do
  # fields
  it { should have_fields(:code, :description) }

  # associations
  it { should have_many :headings }
  it { should belong_to :nomenclature }
  it { should belong_to :section }

  # indexes
  # it { should have_index_for(:code) }

  # misc
  it { should be_timestamped_document }
end
