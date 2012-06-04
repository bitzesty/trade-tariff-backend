require 'spec_helper'

describe Section do
  # fields
  it { should have_fields(:title, :numeral, :position) }

  # associations
  it { should have_many :chapters }
  it { should belong_to :nomenclature }

  # misc
  it { should be_timestamped_document }

  it 'uses position as key param' do
    subject.to_param.should == subject.position
  end
end
