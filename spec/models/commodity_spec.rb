require 'spec_helper'

describe Commodity do
  it 'has primary key set to goods_nomenclature_sid' do
    subject.primary_key.should == :goods_nomenclature_sid
  end
end
