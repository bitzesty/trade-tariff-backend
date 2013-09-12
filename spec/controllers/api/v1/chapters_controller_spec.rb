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

  context 'when record is hidden' do
    let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: chapter.goods_nomenclature_item_id }

    it 'returns not found' do
      expect { get :show, id: chapter.goods_nomenclature_item_id.first(2), format: :json }.to raise_error Sequel::RecordNotFound
    end
  end
end

describe Api::V1::ChaptersController, "GET #index" do
  render_views

  let!(:chapter1) { create :chapter, :with_section, :with_note }
  let!(:chapter2) { create :chapter, :with_section, :with_note }

  let(:pattern) {
    [
      {goods_nomenclature_item_id: String, chapter_note_id: Integer },
      {goods_nomenclature_item_id: String, chapter_note_id: Integer }
    ]
  }

  it 'returns rendered records' do
    get :index, format: :json

    response.body.should match_json_expression pattern
  end
end


describe Api::V1::ChaptersController, "GET #changes" do
  render_views

  let(:chapter) { create :chapter, :with_section, :with_note,
                                   operation_date: Date.today }

  let(:pattern) {
    [
      {
        oid: Integer,
        model_name: "Chapter",
        operation: String,
        operation_date: String,
        record: Hash
      }
    ].ignore_extra_values!
  }

  it 'returns chapter changes' do
    get :changes, id: chapter, format: :json

    response.body.should match_json_expression pattern
  end
end
