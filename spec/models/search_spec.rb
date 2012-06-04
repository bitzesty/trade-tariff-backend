require 'spec_helper'

describe Search do
  describe 'initialization' do
    let(:valid_params) { { q: "abc", page: 1 } }
    let(:invalid_params) { { invalid: "abc", param: 1 } }

    it 'assigns valid search params' do
      search = Search.new(valid_params)
      search.q.should == valid_params[:q]
      search.page.should == valid_params[:page]
    end

    it 'does not assign invalid param' do
      search = Search.new(valid_params)
      -> { search.invalid }.should raise_error
      -> { search.param }.should raise_error
    end
  end

  describe "#persisted?" do
    it 'is not persisted' do
      subject.persisted?.should be_false
    end
  end

  describe "#perform" do
    let(:result_hash) {
      { entries: {},
        current_page: 1,
        total_entries: 100,
        per_page: 25,
        total_pages: 4,
        offset: 0
      }
    }

    let(:result_stub) {
      stub(result_hash.merge(results: {}))
    }

    let(:tire_proxy) { stub() }

    before {
      tire_proxy.expects(:search).returns(result_stub)
      Commodity.expects(:tire).returns(tire_proxy)
    }

    it 'returns search results' do
      subject.perform.diff(result_hash).should == {}
    end
  end
end
