require "rails_helper"
require "cds_importer/entity_mapper"

describe CdsImporter::EntityMapper do
  describe "#process!" do
    before do
      # allow setting primary keys
      Sequel::Model.subclasses.each(&:unrestrict_primary_key)
    end

    it "AdditionalCode sample" do
      hash_double = double(
        :hash_from_node,
        name: "AdditionalCode",
        values: {
          "sid" => 3084,
          "additionalCodeCode" => "169",
          "validityEndDate" => "1996-06-14T23:59:59",
          "validityStartDate" => "1991-06-01T00:00:00",
          "additionalCodeType" => {
            "additionalCodeTypeId" => "8"
          },
          "metainfo" => {
            "origin" => "T",
            "opType" => "U",
            "transactionDate" => "2016-07-27T09:20:15"
          }
        }
      )
      subject = described_class.new(hash_double)
      entity = subject.parse
      expect(entity.additional_code_sid).to eq(hash_double.values["sid"])
      expect(entity.additional_code).to eq(hash_double.values["additionalCodeCode"])
      expect(entity.additional_code_type_id).to eq(hash_double.values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.validity_end_date).to eq(hash_double.values["validityEndDate"])
      expect(entity.validity_start_date).to eq(hash_double.values["validityStartDate"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(hash_double.values["metainfo"]["transactionDate"]))
    end

    it "AdditionalCodeDescription sample" do
      # NB AdditionalCodeDescription is nested inside AdditionalCode
      #   so following hash is a double from AdditionalCode hash
      hash_double = double(
        :hash_from_node,
        name: "AdditionalCodeDescription",
        values: {
          "sid" => 3084,
          "additionalCodeCode" => "169",
          "additionalCodeType" => {
            "additionalCodeTypeId" => "8"
          },
          "additionalCodeDescriptionPeriod" => {
            "sid" => 536,
            "additionalCodeDescription" => {
              "description" => "Other.",
              "language" => {
                "languageId" => "EN"
              },
              "metainfo" => {
                "origin" => "T",
                "opType" => "C",
                "transactionDate" => "2016-07-27T09:20:14"
              }
            }
          }
        }
      )
      # TODO instruct AdditionalCodeMapper on how to parse
      # children AdditionalCodeDescription
      klass = CdsImporter::EntityMapper::AdditionalCodeDescriptionMapper
      entity = klass.new(hash_double.values).parse
      expect(entity.additional_code_description_period_sid).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["sid"])
      expect(entity.language_id).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["additionalCodeDescription"]["language"]["languageId"])
      expect(entity.additional_code_sid).to eq(hash_double.values["sid"])
      expect(entity.additional_code_type_id).to eq(hash_double.values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.additional_code).to eq(hash_double.values["additionalCodeCode"])
      expect(entity.description).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["additionalCodeDescription"]["description"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(hash_double.values["additionalCodeDescriptionPeriod"]["additionalCodeDescription"]["metainfo"]["transactionDate"]))
    end

    it "AdditionalCodeDescriptionPeriod sample" do
      hash_double = double(
        :hash_from_node,
        name: "AdditionalCodeDescriptionPeriod",
        values: {
          "sid" => 3084,
          "additionalCodeCode" => "169",
          "additionalCodeDescriptionPeriod" => {
            "sid" => 536,
            "validityStartDate" => "1991-06-01T00:00:00",
            "validityEndDate" => "1992-06-01T00:00:00",
            "additionalCodeType" => {
              "additionalCodeTypeId" => "8"
            },
            "metainfo" => {
              "opType" => "U",
              "transactionDate" => "2016-07-27T09:20:15"
            }
          }
        }
      )
      klass = CdsImporter::EntityMapper::AdditionalCodeDescriptionPeriodMapper
      entity = klass.new(hash_double.values).parse
      expect(entity.additional_code_description_period_sid).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["sid"])
      expect(entity.additional_code_sid).to eq(hash_double.values["sid"])
      expect(entity.additional_code_type_id).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.additional_code).to eq(hash_double.values["additionalCodeCode"])
      expect(entity.validity_start_date).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["validityStartDate"])
      expect(entity.validity_end_date).to eq(hash_double.values["additionalCodeDescriptionPeriod"]["validityEndDate"])
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(hash_double.values["additionalCodeDescriptionPeriod"]["metainfo"]["transactionDate"]))
    end

    it "GoodsNomenclature sample" do
      values = {
        "sid" => 1234,
        "goodsNomenclatureItemId" => "9950000000",
        "produclineSuffix" => "80",
        "statisticalIndicator" => "2",
        "validityStartDate" => "2017-10-01T00:00:00",
        "validityEndDate" => "2020-09-01T00:00:00",
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2017-09-27T07:26:25"
        }
      }
      subject = CdsImporter::EntityMapper::GoodsNomenclatureMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(GoodsNomenclature)
      expect(entity.goods_nomenclature_sid).to eq(values["sid"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
      expect(entity.producline_suffix).to eq(values["produclineSuffix"])
      expect(entity.statistical_indicator.to_s).to eq(values["statisticalIndicator"])
    end

    it "CompleteAbrogationRegulation sample" do
      values = {
        "regulationRoleType" => {
          "regulationRoleTypeId" => "6"
        },
        "completeAbrogationRegulationId" => "R9808461",
        "publishedDate" => "2017-08-27T10:11:12",
        "officialjournalNumber" => "L 120",
        "officialjournalPage" => "13",
        "replacementIndicator" => "0",
        "informationText" => "TR",
        "approvedFlag" => true,
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2017-09-22T17:26:25"
        }
      }
      subject = CdsImporter::EntityMapper::CompleteAbrogationRegulationMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(CompleteAbrogationRegulation)
      expect(entity.complete_abrogation_regulation_role.to_s).to eq(values["regulationRoleType"]["regulationRoleTypeId"])
      expect(entity.complete_abrogation_regulation_id).to eq(values["completeAbrogationRegulationId"])
      expect(entity.published_date).to eq(Date.parse(values["publishedDate"]))
      expect(entity.officialjournal_number).to eq(values["officialjournalNumber"])
      expect(entity.officialjournal_page.to_s).to eq(values["officialjournalPage"])
      expect(entity.replacement_indicator.to_s).to eq(values["replacementIndicator"])
      expect(entity.information_text).to eq(values["informationText"])
      expect(entity.approved_flag).to eq(values["approvedFlag"])
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end
  end
end
