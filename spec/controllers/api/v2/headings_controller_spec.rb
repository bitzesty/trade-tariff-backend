require 'rails_helper'

describe Api::V2::HeadingsController, 'GET #show' do
  render_views

  context 'non-declarable heading' do
    let(:heading) { create :heading, :non_grouping,
                                     :non_declarable,
                                     :with_description }
    let!(:chapter) { create :chapter,
                     :with_section, :with_description,
                     goods_nomenclature_item_id: heading.chapter_id
    }

    let(:pattern) {
      {
        data: {
          id: String,
          type: String,
          attributes: {
            goods_nomenclature_item_id: heading.code,
            description: String,
          }.ignore_extra_keys!,
          relationships: {
            commodities: Hash,
            chapter: Hash,
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      }.ignore_extra_keys!
    }

    context 'when record is present' do
      
      before { TradeTariffBackend.cache_client.reindex }
      
      it 'returns rendered record' do
        get :show, params: { id: heading }, format: :json
        expect(response.body).to match_json_expression pattern
      end
    end

    context 'when record is present and commodity has hidden commodities' do
      let!(:commodity1) { create :commodity, :with_indent, :with_description, :with_chapter, :declarable, goods_nomenclature_item_id: "#{heading.short_code}010000"}
      let!(:commodity2) { create :commodity, :with_indent, :with_description, :with_chapter, :declarable, goods_nomenclature_item_id: "#{heading.short_code}020000"}

      let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: commodity2.goods_nomenclature_item_id }

      before { TradeTariffBackend.cache_client.reindex }
      
      it 'does not include hidden commodities in the response' do
        get :show, params: { id: heading }, format: :json

        body = JSON.parse(response.body)
        expect(
          body['data']['relationships']['commodities']['data'].map{|c| c['id'] }
        ).to include commodity1.goods_nomenclature_sid.to_s
        expect(
          body['data']['relationships']['commodities']['data'].map{|c| c['goods_nomenclature_item_id'] }
        ).to_not include commodity2.goods_nomenclature_sid.to_s
      end
    end

    context 'when record is not present' do
      it 'returns not found if record was not found' do
        get :show, params: { id: '5555'}, format: :json

        expect(response.status).to eq 404
      end
    end
  end

  context 'declarable heading' do
    let!(:heading) { create :heading, :with_indent,
                                      :with_description,
                                      :declarable }
    let!(:chapter) { create :chapter,
                     :with_section, :with_description,
                     goods_nomenclature_item_id: heading.chapter_id }

    let(:pattern) {
      {
        data: {
          id: String,
          type: 'heading',
          attributes: {
            goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
            description: String,
          }.ignore_extra_keys!,
          relationships: {
            chapter: Hash,
            import_measures: Hash,
            export_measures: Hash,
            footnotes: Hash,
            section: Hash,
          }
        }
      }.ignore_extra_keys!
    }

    context 'when record is present' do
      it 'returns rendered record' do
        get :show, params: { id: heading }, format: :json
        expect(response.body).to match_json_expression pattern
      end
    end

    context 'when record is not present' do
      it 'returns not found if record was not found' do
        get :show, params: { id: '1234'}, format: :json

        expect(response.status).to eq 404
      end
    end

    context 'when record is hidden' do
      let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: heading.goods_nomenclature_item_id }

      it 'returns not found' do
        get :show, params: { id: heading.goods_nomenclature_item_id.first(4) }, format: :json

        expect(response.status).to eq 404
      end
    end
  end
end

describe Api::V2::HeadingsController, 'GET #changes' do
  render_views

  context 'changes happened after chapter creation' do
    let(:heading) { create :heading, :non_grouping,
                                     :non_declarable,
                                     :with_description,
                                     :with_chapter,
                                     operation_date: Date.current }

    let(:pattern) {
      {
        data: [
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Heading',
              operation: 'C',
              operation_date: String
          },
            relationships: {
              record: {
                data: {
                  id: String,
                  type: 'heading'
                }
              }
            }
          }
        ],
        included: [
          {
            id: String,
            type: 'heading',
            attributes: {
              description: String,
              goods_nomenclature_item_id: String,
              validity_start_date: String,
              validity_end_date: nil
           }
          }
        ]
      }
    }

    it 'returns heading changes' do
      get :changes, params: { id: heading }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'changes happened before requested date' do
    let(:heading) { create :heading, :non_grouping,
                                     :non_declarable,
                                     :with_description,
                                     :with_chapter,
                                     operation_date: Date.current }

    let!(:pattern) {
      {
          data: [],
          included: []
      }
    }

    it 'does not include change records' do
      get :changes, params: { id: heading, as_of: Date.yesterday }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'changes include deleted record' do
    let(:heading) { create :heading, :non_grouping,
                                     :non_declarable,
                                     :with_description,
                                     :with_chapter,
                                     operation_date: Date.current }
    let!(:measure) {
      create :measure,
        :with_measure_type,
        goods_nomenclature: heading,
        goods_nomenclature_sid: heading.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
        operation_date: Date.current
    }
    let(:pattern) {
      {
        data: [
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Measure',
              operation: 'C',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: String,
                  type: 'measure'
                }
              }
            }
          }, {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Measure',
              operation: 'D',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: String,
                  type: 'measure'
                }
              }
            }
        }, {
          id: String,
          type: 'change',
          attributes: {
            oid: Integer,
            model_name: 'Heading',
            operation: 'C',
            operation_date: String
          },
          relationships: {
            record: {
              data: {
                id: String,
                type: 'heading'
              }
            }
          }
        }],
        included: [
          {
            id: String,
            type: 'measure',
            attributes: Hash,
            relationships: {
              geographical_area: Hash,
              measure_type: Hash
            }
          }, {
            id: String,
            type: 'geographical_area',
            attributes: Hash
          }, {
            id: String,
            type: 'measure_type',
            attributes: Hash
          }, {
            id: String,
            type: 'heading',
            attributes: Hash
          }
        ]
      }
    }

    before { measure.destroy }

    it 'renders record attributes' do
      get :changes, params: { id: heading }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end
