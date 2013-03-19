require 'spec_helper'

describe SearchService do
  describe 'initialization' do
    let(:query) { Forgery(:basic).text }

    it 'assigns search query' do
      SearchService.new(t: query).t.should == query
    end
  end

  describe "#valid?" do
    it 'is not valid if has no t param assigned' do
      SearchService.new(t: nil).valid?.should be_false
    end

    it 'is not valid if has no as_of param assigned' do
      SearchService.new(t: 'value').valid?.should be_false
    end

    it 'is valid if has both t and as_of params provided' do
      SearchService.new(t: 'value', as_of: Date.today).valid?.should be_true
    end
  end

  # Searching in local tables
  describe 'exact search' do
    around(:each) do |example|
      TimeMachine.now { example.run }
    end

    context 'chapters' do
      context 'chapter goods id has not got preceding zero' do
        let(:chapter) { create :chapter, goods_nomenclature_item_id: '1100000000' }
        let(:pattern) {
          {
            type: 'exact_match',
            entry: {
              endpoint: 'chapters',
              id: chapter.goods_nomenclature_item_id.first(2)
            }
          }
        }

        it 'returns endpoint and identifier if provided with 2 digit chapter code' do
          result = SearchService.new(t: chapter.goods_nomenclature_item_id.first(2),
                                     as_of: Date.today).to_json

          result.should match_json_expression pattern
        end

        it 'returns endpoint and identifier if provided with matching 3 digit chapter code' do
          result = SearchService.new(t: chapter.goods_nomenclature_item_id.first(2),
                                     as_of: Date.today).to_json

          result.should match_json_expression pattern
        end
      end

      context 'chapter goods code id has got preceding zero' do
        let(:chapter) { create :chapter, goods_nomenclature_item_id: '0800000000' }
        let(:pattern) {
          {
            type: 'exact_match',
            entry: {
              endpoint: 'chapters',
              id: "0#{chapter.goods_nomenclature_item_id[1,1]}"
            }
          }
        }

        it 'returns endpoint and identifier if provided with 1 digit chapter code' do
          result = SearchService.new(t: chapter.goods_nomenclature_item_id.first(2),
                                     as_of: Date.today).to_json

          result.should match_json_expression pattern
        end
      end
    end

    context 'headings' do
      let(:heading) { create :heading }
      let(:pattern) {
        {
          type: 'exact_match',
          entry: {
            endpoint: 'headings',
            id: heading.goods_nomenclature_item_id.first(4)
          }
        }
      }

      it 'returns endpoint and identifier if provided with 4 symbol heading code' do
        result = SearchService.new(t: heading.goods_nomenclature_item_id.first(4),
                                   as_of: Date.today).to_json

        result.should match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 6 (or any between length of 4 to 9) symbol heading code' do
        result = SearchService.new(t: heading.goods_nomenclature_item_id.first(6),
                                   as_of: Date.today).to_json

        result.should match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 10 symbol declarable heading code' do
        result = SearchService.new(t: heading.goods_nomenclature_item_id,
                                   as_of: Date.today).to_json

        result.should match_json_expression pattern
      end
    end

    context 'commodities' do
      context 'declarable' do
        let(:commodity) { create :commodity, :declarable, :with_heading, :with_indent }
        let(:heading)   { commodity.heading }
        let(:commodity_pattern) {
          {
            type: 'exact_match',
            entry: {
              endpoint: 'commodities',
              id: commodity.goods_nomenclature_item_id.first(10)
            }
          }
        }
        let(:heading_pattern) {
          {
            type: 'exact_match',
            entry: {
              endpoint: 'headings',
              id: heading.goods_nomenclature_item_id.first(4)
            }
          }
        }

        it 'returns endpoint and identifier if provided with 10 symbol commodity code' do
          result = SearchService.new(t: commodity.goods_nomenclature_item_id.first(10),
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 symbol commodity code separated by spaces' do
          code = [commodity.goods_nomenclature_item_id[0..1],
                  commodity.goods_nomenclature_item_id[2..3],
                  commodity.goods_nomenclature_item_id[4..5],
                  commodity.goods_nomenclature_item_id[6..7],
                  commodity.goods_nomenclature_item_id[8..9]].join("")
          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 digits separated by whitespace of varying length' do
          code =  [commodity.goods_nomenclature_item_id[0..1],
                   commodity.goods_nomenclature_item_id[2..3]].join("")
          code << [commodity.goods_nomenclature_item_id[4..5],
                   commodity.goods_nomenclature_item_id[6..7]].join("     ")
          code << "  " << commodity.goods_nomenclature_item_id[8..9]

          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 symbol commodity code separated by dots' do
          code = [commodity.goods_nomenclature_item_id[0..1],
                  commodity.goods_nomenclature_item_id[2..3],
                  commodity.goods_nomenclature_item_id[4..5],
                  commodity.goods_nomenclature_item_id[6..7],
                  commodity.goods_nomenclature_item_id[8..9]].join(".")
          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 digits separated by various non number characters' do
          code =  [commodity.goods_nomenclature_item_id[0..1],
                   commodity.goods_nomenclature_item_id[2..3]].join("|")
          code << [commodity.goods_nomenclature_item_id[4..5],
                   commodity.goods_nomenclature_item_id[6..7]].join("!!  !!!")
          code << "  " << commodity.goods_nomenclature_item_id[8..9]

          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with matching 12 symbol commodity code' do
          result = SearchService.new(t: commodity.goods_nomenclature_item_id + commodity.producline_suffix,
                                     as_of: Date.today).to_json

          result.should match_json_expression commodity_pattern
        end
      end

      context 'non declarable' do
        let!(:heading)    { create :heading, goods_nomenclature_item_id: '8418000000',
                                             validity_start_date: Date.new(2011,1,1) }
        let!(:commodity1) { create :commodity, :with_indent,
                                               indents: 3,
                                               goods_nomenclature_item_id: '8418213100',
                                               producline_suffix: '80',
                                               validity_start_date: Date.new(2011,1,1) }
        let!(:commodity2) { create :commodity, :with_indent,
                                               indents: 4,
                                               goods_nomenclature_item_id: '8418215100',
                                               producline_suffix: '80',
                                               validity_start_date: Date.new(2011,1,1) }

        let(:heading_pattern) {
          {
            type: 'exact_match',
            entry: {
              endpoint: 'headings',
              id: heading.goods_nomenclature_item_id.first(4)
            }
          }
        }

        it 'does not exact match commodity with children' do
          # even though productline suffix (80) suggests that it is declarable
          result = SearchService.new(t: commodity1.goods_nomenclature_item_id,
                                     as_of: Date.today).to_json

          result.should match_json_expression heading_pattern
        end
      end
    end

    context 'hidden commodities' do
      let!(:commodity)    { create :commodity, :declarable }
      let!(:hidden_gono)  { create :hidden_goods_nomenclature, goods_nomenclature_item_id: commodity.goods_nomenclature_item_id }

      let(:commodity_pattern) {
        {
          type: 'exact_match',
          entry: {
            endpoint: 'commodities',
            id: commodity.goods_nomenclature_item_id.first(10)
          }
        }
      }

      before {
        @result = SearchService.new(t: commodity.goods_nomenclature_item_id.first(10),
                                    as_of: Date.today).to_json
      }

      it 'does not return hidden commodity as exact match' do
        @result.should_not match_json_expression commodity_pattern
      end
    end
  end

  # Searching in ElasticSearch index
  describe 'fuzzy search' do
    context 'filtering by date' do
      context 'with goods codes that have bounded validity period' do

        # heading that has validity period of 1972-01-01 to 2006-12-31
        let(:heading_pattern) {
          {
            type: 'fuzzy_match',
            goods_nomenclature_match: {
              headings: [
                { "goods_nomenclature_item_id"=>"2851000000" }.ignore_extra_keys!
              ].ignore_extra_values!
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }

        it 'returns goods code if search date falls within validity period' do
          VCR.use_cassette("search#fuzzy_date_filter_for_2851000000_2005") do
            @result = SearchService.new(t: "water",
                                        as_of: "2005-01-01").to_json

            @result.should match_json_expression heading_pattern
          end
        end

        it 'does not return goods code if search date does not fall within validity period' do
          VCR.use_cassette("search#fuzzy_date_filter_for_2851000000_2007") do
            @result = SearchService.new(t: "water",
                                        as_of: "2007-01-01").to_json

            @result.should_not match_json_expression heading_pattern
          end
        end
      end

      context 'with goods codes that have unbounded validity period' do
        # heading that has validity period starting from 1972-01-01
        let(:heading_pattern) {
          {
            type: 'fuzzy_match',
            goods_nomenclature_match: {
              headings: [
                { "goods_nomenclature_item_id"=>"0102000000" }.ignore_extra_keys!
              ].ignore_extra_values!
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }

        it 'returns goods code if search date is greater than start of validity period' do
          VCR.use_cassette("search#fuzzy_date_filter_for_0102000000_2007") do
            @result = SearchService.new(t: "animal products",
                                        as_of: "2007-01-01").to_json

            @result.should match_json_expression heading_pattern
          end
        end

        it 'does not return goods code if search date is less than start of validity period' do
          VCR.use_cassette("search#fuzzy_date_filter_for_0102000000_1970") do
            @result = SearchService.new(t: "animal products",
                                        as_of: "1970-01-01").to_json

            @result.should_not match_json_expression heading_pattern
          end
        end
      end
    end
  end

  context 'reference search' do
    let(:heading_pattern) {
      {
        type: 'fuzzy_match',
        reference_match: {
          headings: [
            {
             reference: { "goods_nomenclature_item_id"=>"2851000000" }.ignore_extra_keys!
            }.ignore_extra_keys!
          ].ignore_extra_values!
        }.ignore_extra_keys!
      }.ignore_extra_keys!
    }

    it 'returns goods code if search date falls within validity period' do
      VCR.use_cassette("search#fuzzy_date_filter_for_2851000000_2005") do
        @result = SearchService.new(t: "water",
                                    as_of: "2005-01-01").to_json

        @result.should match_json_expression heading_pattern
      end
    end

    it 'does not return goods code if search date does not fall within validity period' do
      VCR.use_cassette("search#fuzzy_date_filter_for_2851000000_2007") do
        @result = SearchService.new(t: "water",
                                    as_of: "2007-01-01").to_json

        @result.should_not match_json_expression heading_pattern
      end
    end
  end
end
