require 'spec_helper'

describe Api::V1::CommoditiesController, "GET #show" do
  render_views

  let!(:commodity) { create :commodity, :with_indent,
                                        :with_chapter,
                                        :with_heading,
                                        :with_description,
                                        :declarable }
  let(:pattern) {
    {
      goods_nomenclature_item_id: commodity.goods_nomenclature_item_id,
      description: String,
      chapter: Hash,
      section: Hash,
      import_measures: Array,
      export_measures: Array,
    }.ignore_extra_keys!
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: commodity, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      expect { get :show, id: "1234567890", format: :json }.to raise_error Sequel::RecordNotFound
    end
  end

  context 'when record is hidden' do
    let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: commodity.goods_nomenclature_item_id }

    it 'returns not found' do
      expect { get :show, id: commodity.goods_nomenclature_item_id, format: :json }.to raise_error Sequel::RecordNotFound
    end
  end
end
