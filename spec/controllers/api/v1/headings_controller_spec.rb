require 'spec_helper'

describe Api::V1::HeadingsController, "GET #show" do
  render_views

  let(:heading) { create :heading, :non_grouping, :non_declarable, :with_description, :with_chapter }
  let(:pattern) {
    {
      goods_nomenclature_item_id: heading.code,
      description: String,
      commodities: Array,
      chapter: Hash
    }.ignore_extra_keys!
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: heading.to_param, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      expect { get :show, id: "5555", format: :json }.to raise_error Sequel::RecordNotFound
    end
  end
end
