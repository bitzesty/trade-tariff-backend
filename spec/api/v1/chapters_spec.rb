require 'spec_helper'

describe Api::V1 do
  describe "GET /api/chapters/:id" do
    let!(:chapter)    { create(:chapter) }

    before {
      get "/api/chapters/#{chapter.id}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular chapter' do
      subject.at_json_path("id").should == chapter.id.to_s
    end

    # it 'returns associated headings' do
    #   pending
    # end
  end
end
