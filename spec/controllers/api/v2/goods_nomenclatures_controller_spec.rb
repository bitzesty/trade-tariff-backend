require 'rails_helper'

describe Api::V2::GoodsNomenclaturesController, Api::V2::GoodsNomenclaturesController.class do
  render_views

  let!(:goods_nomenclature) do
    create :commodity,
           :with_indent,
           :with_chapter,
           :with_heading
  end
  let(:chapter) { goods_nomenclature.reload.chapter }
  let(:heading) { goods_nomenclature.reload.heading }
  let(:section) { goods_nomenclature.chapter.reload.section }
  let(:pattern_section_and_chapter) do
    {
      data: [
        { # goods_nomenclature
          id: goods_nomenclature.id.to_s,
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
          id: heading.id.to_s,
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
          id: chapter.id.to_s,
          type: 'goods_nomenclature',
          attributes: {
            goods_nomenclature_sid: chapter.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
            description: chapter.description,
            number_indents: Integer,
            producline_suffix: chapter.producline_suffix,
            href: Api::V2::GoodsNomenclaturesController.api_path_builder(chapter)
          }
        }
      ],
    }
  end
  let(:pattern_heading) do
    {
      data: [
        { # goods_nomenclature
          id: goods_nomenclature.id.to_s,
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
          id: heading.id.to_s,
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
  end

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
