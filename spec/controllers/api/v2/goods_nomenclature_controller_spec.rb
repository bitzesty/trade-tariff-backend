require 'rails_helper'

describe Api::V2::GoodsNomenclaturesController, "GET #show_by_section" do
  render_views

  let!(:goods_nomenclature)  { create :commodity,
                                      :with_indent,
                                      :with_chapter,
                                      :with_heading }
  let(:chapter) { goods_nomenclature.reload.chapter }
  let(:heading) { goods_nomenclature.reload.heading }
  let(:section) { goods_nomenclature.chapter.reload.section }
  let(:pattern_section_and_chapter) {
    {
      data: [
        { # goods_nomenclature
          id: "#{goods_nomenclature.id}",
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
            goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id,
            description: goods_nomenclature.description,
            number_indents: goods_nomenclature.number_indents,
            producline_suffix: goods_nomenclature.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(goods_nomenclature)
          }
        },
        { # heading
          id: "#{heading.id}",
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: heading.goods_nomenclature_sid,
            goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
            description: heading.description,
            number_indents: Integer,
            producline_suffix: heading.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(heading)
          }
        },
        { # chapter
          id: "#{chapter.id}",
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: chapter.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
            description: chapter.description,
            number_indents: Integer,#chapter.number_indents,
            producline_suffix: chapter.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(chapter)
          }
        }
      ],
    }
  }
  let(:pattern_heading) {
    {
      data: [
        { # goods_nomenclature
          id: "#{goods_nomenclature.id}",
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
            goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id,
            description: goods_nomenclature.description,
            number_indents: goods_nomenclature.number_indents,
            producline_suffix: goods_nomenclature.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(goods_nomenclature)
          }
        },
        { # heading
          id: "#{heading.id}",
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: heading.goods_nomenclature_sid,
            goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
            description: heading.description,
            number_indents: Integer,
            producline_suffix: heading.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(heading)
          }
        }
      ],
    }
  }

  context 'when GNs for a section are requested' do
    it 'returns rendered record of GNs in the section' do
      get :show_by_section, params: { position: section.position }, format: :json

      expect(response.body).to match_json_expression pattern_section_and_chapter
    end
  end

  context 'when GNs for a chapter are requested' do
    it 'returns rendered record of GNs in the chapter' do
      get :show_by_chapter, params: { chapter_id: chapter.short_code }, format: :json

      expect(response.body).to match_json_expression pattern_section_and_chapter
    end
  end

  context 'when GNs for a heading are requested' do
    it 'returns rendered record of GNs in the heading' do
      get :show_by_heading, params: { heading_id: heading.short_code }, format: :json

      expect(response.body).to match_json_expression pattern_heading
    end
  end
end