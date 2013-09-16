require 'spec_helper'

describe Api::V1::SectionsController, "GET #show" do
  render_views

  let(:chapter) { create :chapter, :with_section }
  let(:section) { chapter.section }

  let(:pattern) {
    {
      id: Integer,
      position: Integer,
      title: String,
      numeral: String,
      chapter_from: String,
      chapter_to: String,
      chapters: Array
    }
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: section.position, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      get :show, id: "5", format: :json

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
    [
      {id: Integer, section_note_id: nil, position: Integer, title: String, numeral: String, chapter_from: String, chapter_to: String},
      {id: Integer, section_note_id: nil, position: Integer, title: String, numeral: String, chapter_from: String, chapter_to: String}
    ]
  }

  it 'returns rendered records' do
    get :index, format: :json

    response.body.should match_json_expression pattern
  end
end
