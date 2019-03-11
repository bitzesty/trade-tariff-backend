require 'rails_helper'

describe Api::V1::SectionsController, "GET #show" do
  render_views

  let(:heading) { create :heading, :with_chapter }
  let(:chapter) { heading.reload.chapter }
  let(:section) { chapter.section }
  let!(:section_note) { create :section_note, section_id: section.id }

  let(:pattern) {
    {
      data: {
        id: String,
        type: String,
        attributes: {
          id: Integer,
          position: Integer,
          title: String,
          numeral: String,
          chapter_from: String,
          chapter_to: String,
          section_note: String,
        },
        relationships: {
          chapters: {
            data: [
              {
                id: String,
                type: String,
              },
            ],
          },
        },
      },
      included: [
        {
          id: String,
          type: String,
          attributes: {
            goods_nomenclature_sid: Integer,
            goods_nomenclature_item_id: String,
            headings_from: String,
            headings_to: String,
            description: String,
            formatted_description: String,
            chapter_note_id: Integer
          },
          relationships: Hash,
        }
      ]
    }
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, params: { id: section.position }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      get :show, params: { id: section.position + 1 }, format: :json

      expect(response.status).to eq 404
    end
  end
end

describe Api::V1::SectionsController, "GET #index" do
  render_views

  let!(:chapter1) { create :chapter, :with_section }
  let!(:chapter2) { create :chapter, :with_section }
  let(:section1)  { chapter1.section }
  let(:section2)  { chapter2.section }

  let(:pattern) {
    {
      data:[
        {id: String, type: String, attributes: {id: Integer, section_note_id: nil, position: Integer, title: String, numeral: String, chapter_from: String, chapter_to: String}},
        {id: String, type: String, attributes: {id: Integer, section_note_id: nil, position: Integer, title: String, numeral: String, chapter_from: String, chapter_to: String}}
      ]
    }
  }

  it 'returns rendered records' do
    get :index, format: :json

    expect(response.body).to match_json_expression pattern
  end
end
