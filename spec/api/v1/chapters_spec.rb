require 'spec_helper'

describe Api::V1 do
  describe "GET /chapters/:id" do
    let!(:chapter)    { create(:chapter_with_headings) }

    before {
      get "/chapters/#{chapter.to_param}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular chapter' do
      subject.at_json_path("short_code").should == chapter.short_code
    end

    it 'returns associated headings' do
      subject.at_json_path("headings").should_not be_blank
    end
  end
end
