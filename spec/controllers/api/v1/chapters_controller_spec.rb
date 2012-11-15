require 'spec_helper'

describe Api::V1::ChaptersController, "GET #show" do
  render_views

  let!(:chapter) { create :chapter, :with_description, :with_section, goods_nomenclature_item_id: "1100000000" }

  let(:pattern) {
    {
      goods_nomenclature_item_id: chapter.code,
      description: String,
      headings: Array,
      section: Hash
    }.ignore_extra_keys!
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: chapter, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      expect { get :show, id: "55", format: :json }.to raise_error Sequel::RecordNotFound
    end
  end
end
