require 'rails_helper'

describe Api::V1::SearchReferencesController, "GET to #index"do
  render_views

  let(:heading) { create :heading }
  let!(:search_reference_heading) {
    create :search_reference, heading: heading, heading_id: heading.to_param, title: 'aa'
  }

  let(:chapter) { create :chapter }
  let!(:search_reference_chapter) {
    create :search_reference, heading: nil, chapter: chapter, chapter_id: chapter.to_param, title: 'bb'
  }

  let(:section) { create :section }
  let!(:search_reference_section) {
    create :search_reference, heading: nil, section: section, section_id: section.to_param, title: 'bb'
  }

  context 'with letter param provided' do
    let(:pattern) {
      [
        {id: Integer, title: String, referenced: Hash, referenced_class: 'Section', referenced_id: String },
        {id: Integer, title: String, referenced: Hash, referenced_class: 'Chapter', referenced_id: String }
      ]
    }

    it 'performs lookup with provided letter' do
      get :index, letter: 'b', format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'with no letter param provided' do
    let(:pattern) {
      [
        {id: Integer, title: String, referenced: Hash, referenced_class: 'Heading', referenced_id: String }
      ]
    }

    it 'peforms lookup with letter A by default' do
      get :index, letter: 'a', format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end
