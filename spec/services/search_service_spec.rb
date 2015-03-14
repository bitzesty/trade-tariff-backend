require 'rails_helper'

describe SearchService do
  describe 'initialization' do
    let(:query) { Forgery(:basic).text }

    it 'assigns search query' do
      expect(
        SearchService.new(t: query).t
      ).to eq query
    end

    it 'strips [, ] characters from search query' do
      expect(
        SearchService.new(t: '[hello] [world]').t
      ).to eq 'hello world'
    end
  end

  describe "#valid?" do
    it 'is not valid if has no t param assigned' do
      expect(
        SearchService.new(t: nil).valid?
      ).to be_falsy
    end

    it 'is not valid if has no as_of param assigned' do
      expect(
        SearchService.new(t: 'value').valid?
      ).to be_falsy
    end

    it 'is valid if has both t and as_of params provided' do
      expect(
        SearchService.new(t: 'value', as_of: Date.today).valid?
      ).to be_truthy
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

          expect(result).to match_json_expression pattern
        end

        it 'returns endpoint and identifier if provided with matching 3 digit chapter code' do
          result = SearchService.new(t: chapter.goods_nomenclature_item_id.first(2),
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression pattern
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

          expect(result).to match_json_expression pattern
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

        expect(result).to match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 6 (or any between length of 4 to 9) symbol heading code' do
        result = SearchService.new(t: heading.goods_nomenclature_item_id.first(6),
                                   as_of: Date.today).to_json

        expect(result).to match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 10 symbol declarable heading code' do
        result = SearchService.new(t: heading.goods_nomenclature_item_id,
                                   as_of: Date.today).to_json

        expect(result).to match_json_expression pattern
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

          expect(result).to match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 symbol commodity code separated by spaces' do
          code = [commodity.goods_nomenclature_item_id[0..1],
                  commodity.goods_nomenclature_item_id[2..3],
                  commodity.goods_nomenclature_item_id[4..5],
                  commodity.goods_nomenclature_item_id[6..7],
                  commodity.goods_nomenclature_item_id[8..9]].join("")
          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 digits separated by whitespace of varying length' do
          code =  [commodity.goods_nomenclature_item_id[0..1],
                   commodity.goods_nomenclature_item_id[2..3]].join("")
          code << [commodity.goods_nomenclature_item_id[4..5],
                   commodity.goods_nomenclature_item_id[6..7]].join("     ")
          code << "  " << commodity.goods_nomenclature_item_id[8..9]

          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 symbol commodity code separated by dots' do
          code = [commodity.goods_nomenclature_item_id[0..1],
                  commodity.goods_nomenclature_item_id[2..3],
                  commodity.goods_nomenclature_item_id[4..5],
                  commodity.goods_nomenclature_item_id[6..7],
                  commodity.goods_nomenclature_item_id[8..9]].join(".")
          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with 10 digits separated by various non number characters' do
          code =  [commodity.goods_nomenclature_item_id[0..1],
                   commodity.goods_nomenclature_item_id[2..3]].join("|")
          code << [commodity.goods_nomenclature_item_id[4..5],
                   commodity.goods_nomenclature_item_id[6..7]].join("!!  !!!")
          code << "  " << commodity.goods_nomenclature_item_id[8..9]

          result = SearchService.new(t: code,
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression commodity_pattern
        end

        it 'returns endpoint and identifier if provided with matching 12 symbol commodity code' do
          result = SearchService.new(t: commodity.goods_nomenclature_item_id + commodity.producline_suffix,
                                     as_of: Date.today).to_json

          expect(result).to match_json_expression commodity_pattern
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

          expect(result).to match_json_expression heading_pattern
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
        expect(@result).to_not match_json_expression commodity_pattern
      end
    end
  end

  # Searching in ElasticSearch index
  describe 'fuzzy search' do
    context 'filtering by date' do
      context 'with goods codes that have bounded validity period' do
        let!(:heading) { create :heading, :with_description,
                                goods_nomenclature_item_id: "2851000000",
                                validity_start_date: Date.new(1972,1,1),
                                validity_end_date: Date.new(2006,12,31),
                                description: 'Other inorganic compounds (including distilled or conductivity water and water of similar purity);' }

        # heading that has validity period of 1972-01-01 to 2006-12-31
        let(:heading_pattern) {
          {
            type: 'fuzzy_match',
            goods_nomenclature_match: {
              headings: [
                { "_source" => {
                  "goods_nomenclature_item_id" => "2851000000"
                }.ignore_extra_keys! }.ignore_extra_keys!
              ].ignore_extra_values!
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }

        it 'returns goods code if search date falls within validity period' do
          @result = SearchService.new(t: "water",
                                      as_of: "2005-01-01").to_json

          expect(@result).to match_json_expression heading_pattern
        end

        it 'does not return goods code if search date does not fall within validity period' do
          @result = SearchService.new(t: "water",
                                      as_of: "2007-01-01").to_json

          expect(@result).to_not match_json_expression heading_pattern
        end
      end

      context 'with goods codes that have unbounded validity period' do
        let!(:heading) { create :heading, :with_description,
                                goods_nomenclature_item_id: "0102000000",
                                validity_start_date: Date.new(1972,1,1),
                                validity_end_date: nil,
                                description: 'Live bovine animals' }

        # heading that has validity period starting from 1972-01-01
        let(:heading_pattern) {
          {
            type: 'fuzzy_match',
            goods_nomenclature_match: {
              headings: [
                { "_source" => {
                    "goods_nomenclature_item_id" => "0102000000"
                  }.ignore_extra_keys!
                }.ignore_extra_keys!
              ].ignore_extra_values!
            }.ignore_extra_keys!
          }.ignore_extra_keys!
        }

        it 'returns goods code if search date is greater than start of validity period' do
          @result = SearchService.new(t: "animal products",
                                      as_of: "2007-01-01").to_json

          expect(@result).to match_json_expression heading_pattern
        end

        it 'does not return goods code if search date is less than start of validity period' do
          @result = SearchService.new(t: "animal products",
                                      as_of: "1970-01-01").to_json

          expect(@result).to_not match_json_expression heading_pattern
        end
      end
    end

    describe 'querying with ambiguous characters' do
      # Ensure we use match (not query_string query)
      # query string interprets queries according to Lucene syntax
      # and we don't need these advanced features

      let(:result) {
        SearchService.new(t: "!!! [t_e_s_t][",
                          as_of: "1970-01-01")
      }

      specify 'search does not raise an exception' do
        expect { result.to_json }.not_to raise_error
      end

      specify 'search returns empty resilt' do
        expect(result.to_json).to match_json_expression SearchService::BaseSearch::BLANK_RESULT.merge(type: 'fuzzy_match')
      end
    end

    context 'searching for sections' do
      # Sections do not have validity periods
      # We have to ensure there is special clause in Elasticsearch
      # query that takes that into account and they get found
      let(:title) { "example title" }
      let!(:section) { create :section, title: title }
      let(:result) {
        SearchService.new(t: title,
                          as_of: "1970-01-01")
      }
      let(:response_pattern) {
        {
          type: 'fuzzy_match',
          goods_nomenclature_match: {
            sections: [
              { "_source" => {
                  "title" => title
                }.ignore_extra_keys!
              }.ignore_extra_keys!
            ].ignore_extra_values!
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      }

      it 'finds relevant sections' do
        expect(result.to_json).to match_json_expression response_pattern
      end
    end

    context "searching with synonyms" do
      include SynonymsHelper

      let(:synonym) { "synonym 1" }
      let(:resources) { %w(section chapter heading commodity) }
      let(:reference_match) {
        SearchService.new(t: synonym, as_of: Date.today).send(:perform).results[:reference_match]
      }

      before {
        # create resources with synonyms
        resources.each do |resource|
          create(resource).tap{ |r|
            2.times do
              create_synonym_for(r, synonym)
            end
          }
        end
      }

      # there shouldn't be duplicates
      it "shouldn't have duplicates" do
        resources.each do |r|
          expect(reference_match[r.pluralize].count).to eq(1)
        end
      end
    end
  end

  context 'reference search' do
    describe 'validity period function' do
      let!(:heading) { create :heading, :with_description,
                              goods_nomenclature_item_id: "2851000000",
                              validity_start_date: Date.new(1972,1,1),
                              validity_end_date: Date.new(2006,12,31),
                              description: 'Test' }
      let!(:search_reference) { create :search_reference,
                                       referenced: heading,
                                       title: 'water'  }

      let(:heading_pattern) {
        {
          type: 'fuzzy_match',
          reference_match: {
            headings: [
              {
                "_source" => {
                   reference: { "goods_nomenclature_item_id"=>"2851000000" }.ignore_extra_keys!
                }.ignore_extra_keys!
              }.ignore_extra_keys!
            ].ignore_extra_values!
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      }

      it 'returns goods code if search date falls within validity period' do
        @result = SearchService.new(t: "water",
                                    as_of: "2005-01-01").to_json

        expect(@result).to match_json_expression heading_pattern
      end

      it 'does not return goods code if search date does not fall within validity period' do
        @result = SearchService.new(t: "water",
                                    as_of: "2007-01-01").to_json

        expect(@result).to_not match_json_expression heading_pattern
      end
    end

    describe 'reference matching for multi term searches' do
      let!(:heading1) { create :heading, :with_description,
                              goods_nomenclature_item_id: "2851000000",
                              description: 'Test 1' }
      let!(:search_reference1) { create :search_reference,
                                        referenced: heading1,
                                        title: 'acid oil' }
      let!(:heading2) { create :heading, :with_description,
                              goods_nomenclature_item_id: "2920000000",
                              description: 'Test 2' }
      let!(:search_reference2) { create :search_reference,
                                        referenced: heading2,
                                        title: 'other kind of oil' } # not 'acid oil'

      let(:heading_pattern) {
        {
          type: 'fuzzy_match',
          reference_match: {
            headings: [
              {
                "_source" => {
                   reference: { "goods_nomenclature_item_id"=> heading1.goods_nomenclature_item_id }.ignore_extra_keys!
                }.ignore_extra_keys!
              }.ignore_extra_keys!
            ]
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      }

      it 'only matches exact phrases' do
        @result = SearchService.new(t: 'acid oil',
                                    as_of: Date.today).to_json

        expect(@result).to match_json_expression heading_pattern
      end
    end
  end
end
