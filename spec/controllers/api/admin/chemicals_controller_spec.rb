require 'rails_helper'

describe Api::Admin::ChemicalsController do
  render_views

  let(:chemical) { create :chemical, :with_name }
  let(:response_pattern_collection) do
    {
      data: [response_pattern_inner]
    }
  end
  let(:response_pattern_object) do
    {
      data: response_pattern_inner
    }
  end
  let(:response_pattern_inner) do
    {
      id: String,
      type: String,
      attributes: {
        id: String,
        cas: String,
        name: String,
        goods_nomenclature_map: { }.ignore_extra_keys!
      },
      relationships: {
        goods_nomenclatures: {
          data: [{
            id: String,
            type: String
          }].ignore_extra_values!
        },
        chemical_names: {
          data: [{
            id: String,
            type: String
          }].ignore_extra_values!
        }
      },
      links: {
        uri: String
      }
    }
  end
  let(:json_body) do
    JSON.parse(response.body)['data']
  end
  let(:commodity) { create :commodity }
  let(:commodity2) { create :commodity }
  let(:commodity3) { create :commodity }
  let(:association) do
    create :chemicals_goods_nomenclatures,
           chemical_id: chemical.id,
           goods_nomenclature_sid: commodity.goods_nomenclature_sid
  end

  before do
    login_as_api_user
    expect(association).to exist
  end

  specify 'GET to #index returns collection of chemicals' do
    get :index, format: :json
    commodity_ids = json_body.map { |f| f['relationships']['goods_nomenclatures']['data'].map { |gn| gn['id'] } }.flatten

    expect(response.body).to match_json_expression response_pattern_collection
    expect(commodity_ids).to include commodity.pk.to_s
  end

  specify 'GET to #show returns a chemical' do
    get :show, format: :json, params: { id: chemical.pk }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity.pk.to_s
  end

  specify 'CREATE: POST to `/admin/chemicals/:chemical_id/map/:gn_id` returns the chemical, now associated with the new commodity' do
    post :create_map, format: :json, params: { chemical_id: chemical.id, gn_id: commodity2.pk }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity2.pk.to_s
  end

  specify 'UPDATE: PUT (also PATCH) to `/admin/chemicals/:chemical_id/map/:gn_id` returns the chemical, now associated with the new commodity and not associated with the old commodity' do
    put :update_map, format: :json, params: { chemical_id: chemical.id, gn_id: commodity.pk, new_id: commodity3.goods_nomenclature_item_id }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity3.pk.to_s
    expect(commodity_ids & [commodity.pk.to_s]).to be_empty
  end

  specify 'DELETE: DELETE to `DELETE /admin/chemicals/:chemical_id/map/:gn_id` returns the returns the chemical, with a 200 OK response' do
    post :create_map, format: :json, params: { chemical_id: chemical.id, gn_id: commodity2.pk }
    put :delete_map, format: :json, params: { chemical_id: chemical.id, gn_id: commodity.pk }

    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).not_to include commodity.pk.to_s
    expect(commodity_ids).to include commodity2.pk.to_s
  end
end
