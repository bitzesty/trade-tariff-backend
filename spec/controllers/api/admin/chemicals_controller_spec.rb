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
        goods_nomenclature_map: {}.ignore_extra_keys!
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
  let(:response_pattern_chemical_object) do
    {
      data: {
        id: String,
        type: String,
        attributes: {
          id: String,
          cas: String,
          name: String,
          goods_nomenclature_map: {}.ignore_extra_keys!
        },
        relationships: {
          goods_nomenclatures: {
            data: []
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
  let(:created_chemical_params) do
    {
      data: {
        attributes: {
          cas: "9-99-9",
          name: "Unobtainium (pure)"
        }
      }
    }
  end
  let(:updated_chemical_params) do
    {
      chemical_id: chemical.id,
      cas: "7-77-7",
      chemical_name_id: chemical.chemical_name_ids.first,
      new_chemical_name: "Dilithium crystals"
    }
  end

  before do
    login_as_api_user
  end

  specify 'POST to `/admin/chemicals` returns the newly created chemical' do
    post :create, format: :json, params: created_chemical_params

    expect(response.body).to match_json_expression response_pattern_chemical_object
    expect(json_body['attributes']['name']).to eq created_chemical_params[:data][:attributes][:name]
  end

  specify 'PUT (also PATCH) to `/admin/chemicals/:chemical_id(/:chemical_name_id/:new_chemical_name)` returns the updated chemical' do
    put :update, format: :json, params: updated_chemical_params

    expect(response.body).to match_json_expression response_pattern_chemical_object
    expect(json_body['attributes']['name']).to eq updated_chemical_params[:new_chemical_name]
    expect(json_body['attributes']['cas']).to eq updated_chemical_params[:cas]
  end

  specify 'GET to #index returns collection of chemicals' do
    expect(association).to exist

    get :index, format: :json
    commodity_ids = json_body.map { |f| f['relationships']['goods_nomenclatures']['data'].map { |gn| gn['id'] } }.flatten

    expect(response.body).to match_json_expression response_pattern_collection
    expect(commodity_ids).to include commodity.pk.to_s
  end

  specify 'GET to #show returns a chemical' do
    expect(association).to exist

    get :show, format: :json, params: { chemical_id: chemical.pk }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity.pk.to_s
  end

  specify 'CREATE: POST to `/admin/chemicals/:chemical_id/map/:goods_nomenclature_sid` returns the chemical, now associated with the new commodity' do
    expect(association).to exist

    post :create_map, format: :json, params: { chemical_id: chemical.id, goods_nomenclature_item_id: commodity2.goods_nomenclature_item_id }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity2.pk.to_s
  end

  specify 'UPDATE: PUT (also PATCH) to `/admin/chemicals/:chemical_id/map/:goods_nomenclature_sid/:goods_nomenclature_item_id` returns the chemical, now associated with the new commodity and not associated with the old commodity' do
    expect(association).to exist

    put :update_map, format: :json, params: {
      chemical_id: chemical.id,
      goods_nomenclature_sid: commodity.id,
      goods_nomenclature_item_id: commodity3.goods_nomenclature_item_id
    }
    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).to include commodity3.pk.to_s
    expect(commodity_ids & [commodity.pk.to_s]).to be_empty
  end

  specify 'DELETE: DELETE to `/admin/chemicals/:chemical_id/map/:goods_nomenclature_sid` returns the returns the chemical, with a 200 OK response' do
    post :create_map, format: :json, params: { chemical_id: chemical.id, goods_nomenclature_item_id: commodity2.goods_nomenclature_item_id }
    delete :delete_map, format: :json, params: { chemical_id: chemical.id, goods_nomenclature_sid: commodity.pk }

    commodity_ids = json_body['relationships']['goods_nomenclatures']['data'].map { |f| f['id'] }

    expect(response.body).to match_json_expression response_pattern_object
    expect(commodity_ids).not_to include commodity.pk.to_s
    expect(commodity_ids).to include commodity2.pk.to_s
  end
end
