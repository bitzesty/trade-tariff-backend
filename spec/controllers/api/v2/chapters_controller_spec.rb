require 'rails_helper'

describe Api::V2::ChaptersController, "GET #show" do
  render_views

  let(:heading) { create :heading, :with_chapter }
  let(:chapter) { heading.reload.chapter }
  let!(:section) { chapter.section }
  let!(:section_note) { create :section_note, section_id: section.id }
  let(:chapter_guide) { chapter.guides.first }
  let!(:chapter_note) { chapter.chapter_note }

  let(:pattern) {
    {
      data: {
        id: "#{chapter.goods_nomenclature_sid}",
        type: 'chapter',
        attributes: {
          goods_nomenclature_sid: chapter.goods_nomenclature_sid,
          goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
          description: chapter.description,
          formatted_description: chapter.formatted_description,
          chapter_note_id: chapter_note.id,
          chapter_note: chapter_note.content,
          section_id: section.id
        },
        relationships: {
          section: {
            data: {
              id: "#{section.id}",
              type: 'section'
            }
          },
          guides: {
            data: [
              {
                id: "#{chapter_guide.id}",
                type: 'guide'
              }
            ]
          },
          headings: {
            data: [
              {
                id: "#{heading.goods_nomenclature_sid}",
                type: 'heading'
              }
            ]
          }
        },
      },
      included: [
        {
          id: "#{chapter.section.id}",
          type: 'section',
          attributes: {
            id: section.id,
            position: section.position,
            title: section.title,
            numeral: section.numeral,
            section_note: section_note.content,
          }
        },
        {
          id: "#{chapter_guide.id}",
          type: 'guide',
          attributes: {
            title: chapter_guide.title,
            url: chapter_guide.url,
          }
        },
        {
          id: "#{heading.goods_nomenclature_sid}",
          type: 'heading',
          attributes: {
            goods_nomenclature_sid: heading.goods_nomenclature_sid,
            goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
            declarable: heading.declarable,
            description: heading.description,
            producline_suffix: heading.producline_suffix,
            leaf: true,
            description_plain: heading.description_plain,
            formatted_description: heading.formatted_description
          }
        }
      ]
    }
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, params: { id: chapter }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      get :show, params: { id: "55" }, format: :json

      expect(response.status).to eq 404
    end
  end

  context 'when record is hidden' do
    let!(:hidden_goods_nomenclature) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: chapter.goods_nomenclature_item_id }

    it 'returns not found' do
      get :show, params: { id: chapter.goods_nomenclature_item_id.first(2) }, format: :json

      expect(response.status).to eq 404
    end
  end
end

describe Api::V2::ChaptersController, "GET #index" do
  render_views

  let!(:chapter1) { create :chapter, :with_section, :with_note }
  let!(:chapter2) { create :chapter, :with_section, :with_note }

  let(:pattern) {
    {
      data: [
        {
          id: "#{chapter1.goods_nomenclature_sid}",
          type: 'chapter',
          attributes: {
            goods_nomenclature_sid: chapter1.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter1.goods_nomenclature_item_id,
            chapter_note_id: chapter1.chapter_note.id,
          }
        },
        {
          id: "#{chapter2.goods_nomenclature_sid}",
          type: 'chapter',
          attributes: {
            goods_nomenclature_sid: chapter2.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter2.goods_nomenclature_item_id,
            chapter_note_id: chapter2.chapter_note.id,
          }
        },
      ]
    }
  }

  it 'returns rendered records' do
    get :index, format: :json

    expect(response.body).to match_json_expression pattern
  end
end


describe Api::V2::ChaptersController, "GET #changes" do
  render_views

  context 'changes happened after chapter creation' do
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
                  id: "#{measure.measure_sid}",
                  type: 'measure'
                }
              }
            }
          },
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Chapter',
              operation: 'C',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: "#{chapter.goods_nomenclature_sid}",
                  type: 'chapter'
                }
              }
            }
          },
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Chapter',
              operation: 'U',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: "#{chapter.goods_nomenclature_sid}",
                  type: 'chapter'
                }
              }
            }
          }
        ],
        included: [
          {
            id: "#{measure.measure_sid}",
            type: 'measure',
            attributes: {
              id: measure.measure_sid,
              origin: measure.origin,
              import: measure.import,
              goods_nomenclature_item_id: measure.goods_nomenclature_item_id
            },
            relationships: {
              geographical_area: {
                data: {
                  id: "#{measure.geographical_area.id}",
                  type: 'geographical_area'
                }
              },
              measure_type: {
                data: {
                  id: "#{measure.measure_type.id}",
                  type: 'measure_type'
                }
              }
            }
          },
          {
            id: "#{measure.geographical_area.id}",
            type: 'geographical_area',
            attributes: {
              id: "#{measure.geographical_area.id}",
              description: measure.geographical_area.geographical_area_description.description
            }
          },
          {
            id: "#{measure.measure_type.id}",
            type: 'measure_type',
            attributes: {
              id: "#{measure.measure_type.id}",
              description: measure.measure_type.description
            }
          },
          {
            id: "#{chapter.goods_nomenclature_sid}",
            type: 'chapter',
            attributes: {
              description: chapter.description,
              goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
              validity_start_date: chapter.validity_start_date,
              validity_end_date: chapter.validity_end_date
            }
          },
        ]
      }
    }

    it 'returns chapter changes' do
      get :changes, params: { id: chapter }, format: :json

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

    let!(:pattern) {
      {
        data: [],
        included: []
      }
    }

    it 'does not include change records' do
      get :changes, params: { id: chapter, as_of: Date.yesterday }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'changes include deleted record' do
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
                  id: "#{measure.measure_sid}",
                  type: 'measure'
                }
              }
            }
          },
          {
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
                  id: "#{measure.measure_sid}",
                  type: 'measure'
                }
              }
            }
          },
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Chapter',
              operation: 'C',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: "#{chapter.goods_nomenclature_sid}",
                  type: 'chapter'
                }
              }
            }
          },
          {
            id: String,
            type: 'change',
            attributes: {
              oid: Integer,
              model_name: 'Chapter',
              operation: 'U',
              operation_date: String
            },
            relationships: {
              record: {
                data: {
                  id: "#{chapter.goods_nomenclature_sid}",
                  type: 'chapter'
                }
              }
            }
          }
        ],
        included: [
          {
            id: "#{measure.measure_sid}",
            type: 'measure',
            attributes: {
              id: measure.measure_sid,
              origin: measure.origin,
              import: measure.import,
              goods_nomenclature_item_id: measure.goods_nomenclature_item_id
            },
            relationships: {
              geographical_area: {
                data: {
                  id: "#{measure.geographical_area.id}",
                  type: 'geographical_area'
                }
              },
              measure_type: {
                data: {
                  id: "#{measure.measure_type.id}",
                  type: 'measure_type'
                }
              }
            }
          },
          {
            id: "#{measure.geographical_area.id}",
            type: 'geographical_area',
            attributes: {
              id: "#{measure.geographical_area.id}",
              description: measure.geographical_area.geographical_area_description.description
            }
          },
          {
            id: "#{measure.measure_type.id}",
            type: 'measure_type',
            attributes: {
              id: "#{measure.measure_type.id}",
              description: measure.measure_type.description
            }
          },
          {
            id: "#{chapter.goods_nomenclature_sid}",
            type: 'chapter',
            attributes: {
              description: chapter.description,
              goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
              validity_start_date: chapter.validity_start_date,
              validity_end_date: chapter.validity_end_date
            }
          },
        ]
      }
    }

    before { measure.destroy }

    it 'renders record attributes' do
      get :changes, params: { id: chapter }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end
