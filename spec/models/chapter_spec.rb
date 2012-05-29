require 'spec_helper'

describe Chapter do
  # fields
  it { should have_fields(:code, :description) }

  # associations
  it { should have_many :headings }
  it { should belong_to :nomenclature }
  it { should belong_to :section }

  # indexes
  # it { should have_index_for(:short_code) }

  # validations
  it { should validate_presence_of(:short_code) }
  it { should validate_length_of(:short_code) }

  # misc
  it { should be_timestamped_document }
end
