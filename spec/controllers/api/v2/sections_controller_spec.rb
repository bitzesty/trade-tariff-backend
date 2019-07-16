require 'rails_helper'

describe Api::V2::SectionsController, "GET #show" do
  render_views

  let(:heading) { create :heading, :with_chapter }
  let(:chapter) { heading.reload.chapter }
  let(:chapter_guide) { chapter.guides.first }
  let(:section) { chapter.section }
  let!(:section_note) { create :section_note, section_id: section.id }

  let(:pattern) {
    {
      data: {
        id: "#{section.id}",
        type: 'section',
        attributes: {
          id: section.id,
          position: section.position,
          title: section.title,
          numeral: section.numeral,
          chapter_from: section.chapter_from,
          chapter_to: section.chapter_to,
          section_note: section_note.content
        },
        relationships: {
          chapters: {
            data: [
              {
                id: "#{chapter.id}",
                type: 'chapter',
              },
            ],
          },
        },
      },
      included: [
        {
          id: "#{chapter.id}",
          type: 'chapter',
          attributes: {
            goods_nomenclature_sid: chapter.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
            headings_from: chapter.headings_from,
            headings_to: chapter.headings_to,
            description: chapter.description,
            formatted_description: chapter.formatted_description
          },
          relationships: {
            guides: {
              data: [
                {
                  id: "#{chapter_guide.id}",
                  type: 'guide',
                }
              ]
            }
          },
        },
        {
          id: "#{chapter_guide.id}",
          type: 'guide',
          attributes: {
            title: chapter_guide.title,
            url: chapter_guide.url,
          }
        },
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

describe Api::V2::SectionsController, "GET #index" do
  render_views

  let!(:chapter1) { create :chapter, :with_section }
  let!(:chapter2) { create :chapter, :with_section }
  let(:section1)  { chapter1.section }
  let(:section2)  { chapter2.section }
  let!(:section_note) { create :section_note, section_id: section1.id }

  let(:pattern) {
    {
      data: [
        {
          id: "#{section1.id}",
          type: 'section',
          attributes: {
            id: section1.id,
            position: section1.position,
            title: section1.title,
            numeral: section1.numeral,
            chapter_from: section1.chapter_from,
            chapter_to: section1.chapter_to
          }
        },
        {
          id: "#{section2.id}",
          type: 'section',
          attributes: {
            id: section2.id,
            position: section2.position,
            title: section2.title,
            numeral: section2.numeral,
            chapter_from: section2.chapter_from,
            chapter_to: section2.chapter_to
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
