require 'spec_helper'
require 'sequel/extensions/pagination_compat'

describe Sequel::PaginationExtension do
  describe '.paginate' do
    let!(:commodity1) { create :commodity }
    let!(:commodity2) { create :commodity }

    it 'supports regular Sequel pagination API' do
      Commodity.dataset
               .paginate(2, 1)
               .order(Sequel.asc(:goods_nomenclature_sid))
               .first
               .should == commodity2
    end

    it 'supports Kaminari style pagination API' do
      Commodity.dataset
               .paginate(page: 2, per_page: 1)
               .order(Sequel.asc(:goods_nomenclature_sid))
               .first
               .should == commodity2
    end
  end
end
