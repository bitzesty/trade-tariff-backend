require 'spec_helper'

describe Section do
  describe '.to_param' do
    let(:section) { create :section }

    it 'uses position as param' do
      section.to_param.should == section.position
    end
  end
end
