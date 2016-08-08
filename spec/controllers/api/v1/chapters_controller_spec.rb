require 'rails_helper'

describe Api::V1::ChaptersController, "GET #show" do
  render_views

  let!(:chapter) { create :chapter, :with_description, :with_section, goods_nomenclature_item_id: "1100000000" }
  let!(:section_note) { create :section_note, section: chapter.section }

  let(:pattern) {
    {
      goods_nomenclature_item_id: chapter.code,
      description: String,
      headings: Array,
      section: {
        section_note: String
      }.ignore_extra_keys!,
      _response_info: Hash
    }.ignore_extra_keys!
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: chapter, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      get :show, id: "55", format: :json

      expect(response.status).to eq 404
    end
  end

  context 'when record is hidden' do
    let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: chapter.goods_nomenclature_item_id }

    it 'returns not found' do
      get :show, id: chapter.goods_nomenclature_item_id.first(2), format: :json

      expect(response.status).to eq 404
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

    expect(response.body).to match_json_expression pattern
  end
end


describe Api::V1::ChaptersController, "GET #changes" do
  render_views

  context 'changes happened after chapter creation' do
    let(:chapter) { create :chapter, :with_section, :with_note,
                                     operation_date: Date.today }

    let(:heading) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000" }
    let!(:measure) {
      create :measure,
        :with_measure_type,
        goods_nomenclature: heading,
        goods_nomenclature_sid: heading.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
        operation_date: Date.today
    }

    let(:pattern) {
      [
        {
          oid: Integer,
          model_name: "Measure",
          record: {
            measure_type: {
              description: measure.measure_type.description
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }.ignore_extra_keys!,
        {
          oid: Integer,
          model_name: "Chapter",
          operation: String,
          operation_date: String,
          record: {
            description: String,
            goods_nomenclature_item_id: String,
            validity_start_date: String,
            validity_end_date: nil
          }
        }
      ].ignore_extra_values!
    }

    it 'returns chapter changes' do
      get :changes, id: chapter, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'changes happened before requested date' do
    let(:chapter) { create :chapter, :with_section, :with_note,
                                     operation_date: Date.current }
    let(:heading) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000" }
    let!(:measure) {
      create :measure,
        :with_measure_type,
        goods_nomenclature: heading,
        goods_nomenclature_sid: heading.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
        operation_date: Date.current
    }

    it 'does not include change records' do
      get :changes, id: chapter, as_of: Date.yesterday, format: :json

      expect(response.body).to match_json_expression []
    end
  end

  context 'changes include deleted record' do
    let(:chapter) { create :chapter, :with_section, :with_note,
                                     operation_date: Date.today }

    let(:heading) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000" }
    let!(:measure) {
      create :measure,
        :with_measure_type,
        goods_nomenclature: heading,
        goods_nomenclature_sid: heading.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
        operation_date: Date.today
    }

    let(:pattern) {
      [
        {
          oid: Integer,
          model_name: "Measure",
          operation: "D",
          record: {
            goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
            measure_type: {
              description: measure.measure_type.description
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }.ignore_extra_keys!,
        {
          oid: Integer,
          model_name: "Chapter",
          operation: String,
          operation_date: String,
          record: {
            description: String,
            goods_nomenclature_item_id: String,
            validity_start_date: String,
            validity_end_date: nil
          }
        }
      ].ignore_extra_values!
    }

    before { measure.destroy }

    it 'renders record attributes' do
      get :changes, id: chapter, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end
