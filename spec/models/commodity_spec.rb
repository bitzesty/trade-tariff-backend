require 'spec_helper'

describe Commodity do
  # fields
  it { should have_fields(:code, :description, :hier_pos, :substring) }

  # associations
  it { should have_many :measures }
  it { should belong_to :nomenclature }
  it { should belong_to :heading }

  # indexes
  # it { should have_index_for(:code) }

  # misc
  it { should be_timestamped_document }

  describe ".leaves" do
    let!(:leaf_commodity) { create :commodity }
    let!(:commodity_with_children) { create :commodity_with_children }

    it "returns commodities that arent parents for anybody (i.e. are leaves)" do
      commodities = Commodity.leaves.entries
      commodities.should include leaf_commodity
      commodities.should include commodity_with_children.children.first
      commodities.should_not include commodity_with_children
    end
  end
end
