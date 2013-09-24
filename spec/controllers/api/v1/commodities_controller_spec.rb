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
      get :show, id: "1234567890", format: :json

      expect(response.status).to eq 404
    end
  end

  context 'when record is hidden' do
    let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: commodity.goods_nomenclature_item_id }

    it 'returns not found' do
      get :show, id: commodity.goods_nomenclature_item_id, format: :json

      expect(response.status).to eq 404
    end
  end

  context 'when commodity has children' do
    # According to Taric manual, commodities that have product line suffix of
    # 80 are not declarable. Unfortunately this is not always the case, sometimes
    # productline suffix is 80, but commodity has children and therefore should also
    # be considered to be non-declarable.
    let!(:heading) { create :goods_nomenclature, goods_nomenclature_item_id: '3903000000'}
    let!(:parent_commodity) { create :commodity, :with_indent,
                                                 :with_chapter,
                                                 indents: 2,
                                                 goods_nomenclature_item_id: '3903909000',
                                                 producline_suffix: '80' }
    let!(:child_commodity)  { create :commodity, :with_indent,
                                                indents: 3,
                                                goods_nomenclature_item_id: '3903909065',
                                                producline_suffix: '80'}

    it 'returns not found (is not declarable)' do
      get :show, id: parent_commodity.goods_nomenclature_item_id, format: :json

      expect(response.status).to eq 404
    end
  end
end

describe Api::V1::CommoditiesController, "GET #changes" do
  render_views

  let!(:commodity) { create :commodity, :with_indent,
                                        :with_chapter,
                                        :with_heading,
                                        :with_description,
                                        :declarable,
                                        operation_date: Date.today }

  let(:pattern) {
    [
      {
        oid: Integer,
        model_name: "GoodsNomenclature",
        operation: String,
        operation_date: String,
        record: Hash
      }
    ].ignore_extra_values!
  }

  it 'returns commodity changes' do
    get :changes, id: commodity, format: :json

    response.body.should match_json_expression pattern
  end
end
