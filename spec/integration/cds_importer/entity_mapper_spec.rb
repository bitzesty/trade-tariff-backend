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

    it "AdditionalCodeType sample" do
      values = {
        "applicationCode" => "1",
        "additionalCodeTypeId" => "3",
        "validityStartDate" => "1970-01-01T00:00:00",
        "meursingTablePlan" => {
          "meursingTablePlanId" => "01"
        },
        "metainfo" => {
          "origin" => "T",
          "opType" => "U",
          "transactionDate" => "2016-07-27T09:18:51"
        }
      }
      subject = CdsImporter::EntityMapper::AdditionalCodeTypeMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(AdditionalCodeType)
      expect(entity.additional_code_type_id).to eq(values["additionalCodeTypeId"])
      expect(entity.validity_start_date).to eq(values["validityStartDate"])
      expect(entity.application_code).to eq(values["applicationCode"])
      expect(entity.meursing_table_plan_id).to eq(values["meursingTablePlan"]["meursingTablePlanId"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end

    it "AdditionalCodeTypeDescription sample" do
      values = {
        "additionalCodeTypeId" => "3",
        "additionalCodeTypeDescription" => {
          "description" => "Prohibition/Restriction/Surveillance",
          "language" => {
            "languageId" => "EN"
          },
          "metainfo" => {
            "origin" => "T",
            "opType" => "C",
            "transactionDate" => "2016-07-27T09:18:51"
          }
        }
      }
      subject = CdsImporter::EntityMapper::AdditionalCodeTypeDescriptionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(AdditionalCodeTypeDescription)
      expect(entity.additional_code_type_id).to eq(values["additionalCodeTypeId"])
      expect(entity.language_id).to eq(values["additionalCodeTypeDescription"]["language"]["languageId"])
      expect(entity.description).to eq(values["additionalCodeTypeDescription"]["description"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["additionalCodeTypeDescription"]["metainfo"]["transactionDate"]))
    end

    it "AdditionalCodeTypeMeasureType sample" do
      values = {
        "additionalCodeTypeMeasureType" => {
          "validityStartDate" => "1999-09-01T00:00:00",
          "measureType" => {
            "measureTypeId" => "468"
          },
          "additionalCodeType" => {
            "additionalCodeTypeId" => "3"
          },
          "metainfo" => {
            "opType" => "C",
            "origin" => "N",
            "transactionDate" => "2016-07-22T20:03:35"
          }
        }
      }
      subject = CdsImporter::EntityMapper::AdditionalCodeTypeMeasureTypeMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(AdditionalCodeTypeMeasureType)
      expect(entity.measure_type_id).to eq(values["additionalCodeTypeMeasureType"]["measureType"]["measureTypeId"])
      expect(entity.additional_code_type_id).to eq(values["additionalCodeTypeMeasureType"]["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.validity_start_date).to eq(values["additionalCodeTypeMeasureType"]["validityStartDate"])
      expect(entity.operation).to eq(:create)
      expect(entity.national).to be_truthy
      expect(entity.operation_date).to  eq(Date.parse(values["additionalCodeTypeMeasureType"]["metainfo"]["transactionDate"]))
    end

    it "DutyExpressionDescription sample" do
      values = {
        "sid" => 123456,
        "dutyExpressionId" => "1234",
        "validityStartDate" => "2017-10-01T00:00:00",
        "validityEndDate" => "2020-09-01T00:00:00",
        "dutyExpressionDescription" => {
          "description" => "Some description",
          "language" => {
            "languageId" => "EN"
          },
          "metainfo" => {
            "origin" => "T",
            "opType" => "C",
            "transactionDate" => "2016-07-27T09:20:14"
          }
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-09-27T07:26:25"
        }
      }
      subject = CdsImporter::EntityMapper::DutyExpressionDescriptionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(DutyExpressionDescription)
      expect(entity.duty_expression_id).to eq(values["dutyExpressionId"])
      expect(entity.language_id).to eq(values["dutyExpressionDescription"]["language"]["languageId"])
      expect(entity.description).to eq(values["dutyExpressionDescription"]["description"])
      expect(entity.operation_date).to eq(Date.parse(values["dutyExpressionDescription"]["metainfo"]["transactionDate"]))
      expect(entity.operation).to eq(:create)
    end

    it "CompleteAbrogationRegulation sample" do
      values = {
        "regulationRoleType" => {
          "sid" => 4321,
          "regulationRoleTypeId" => "7"
        },
        "completeAbrogationRegulationId" => "R9808461",
        "publishedDate" => "2017-08-27T10:11:12",
        "officialjournalNumber" => "L 120",
        "officialjournalPage" => "13",
        "replacementIndicator" => "0",
        "abrogationDate" => "2017-09-21T10:07:31",
        "informationText" => "TR",
        "approvedFlag" => true,
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2017-09-22T17:26:25"
        }
      }
      subject = CdsImporter::EntityMapper::ExplicitAbrogationRegulationMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(ExplicitAbrogationRegulation)
      expect(entity.explicit_abrogation_regulation_role.to_s).to eq(values["regulationRoleType"]["regulationRoleTypeId"])
      expect(entity.explicit_abrogation_regulation_id).to eq(values["explicitAbrogationRegulationId"])
      expect(entity.published_date).to eq(Date.parse(values["publishedDate"]))
      expect(entity.officialjournal_number).to eq(values["officialjournalNumber"])
      expect(entity.officialjournal_page.to_s).to eq(values["officialjournalPage"])
      expect(entity.replacement_indicator.to_s).to eq(values["replacementIndicator"])
      expect(entity.abrogation_date).to eq(Date.parse(values["abrogationDate"]))
      expect(entity.information_text).to eq(values["informationText"])
      expect(entity.approved_flag).to eq(values["approvedFlag"])
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end

    it "ExportRefundNomenclature sample" do
      values = {
        "sid" => 1233,
        "exportRefundCode" => "700",
        "productLine" => "80",
        "additionalCodeType" => {
          "additionalCodeTypeId" => "8"
        },
        "goodsNomenclature" => {
          "sid" => 1234,
          "goodsNomenclatureItemId" => "9950000000",
          "produclineSuffix" => "80",
          "statisticalIndicator" => "2",
          "validityStartDate" => "2017-10-01T00:00:00",
          "validityEndDate" => "2020-09-01T00:00:00",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-09-27T07:26:25"
          }
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-08-21T17:21:35"
        }
      }
      subject = CdsImporter::EntityMapper::ExportRefundNomenclatureMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(ExportRefundNomenclature)
      expect(entity.export_refund_nomenclature_sid).to eq(values["sid"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclature"]["goodsNomenclatureItemId"])
      expect(entity.goods_nomenclature_sid).to eq(values["goodsNomenclature"]["sid"])
      expect(entity.additional_code_type).to eq(values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.export_refund_code).to eq(values["exportRefundCode"])
      expect(entity.productline_suffix).to eq(values["productLine"])
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
      expect(entity.operation).to eq(:update)
    end

    it "ExportRefundNomenclatureIndent sample" do
      values = {
        "sid" => 1233,
        "exportRefundCode" => "700",
        "productLine" => "80",
        "exportRefundNomenclatureIndents" => {
          "sid" => 3322,
          "numberExportRefundNomenclatureIndents" => 2,
          "validityStartDate" => "2015-06-11T00:00:00",
          "validityEndDate" => "2020-04-03T00:00:00",
          "metainfo" => {
            "opType" => "C",
            "transactionDate" => "2017-07-22T15:22:15"
          }
        },
        "additionalCodeType" => {
          "additionalCodeTypeId" => "8"
        },
        "goodsNomenclature" => {
          "sid" => 1234,
          "goodsNomenclatureItemId" => "9950000000",
          "produclineSuffix" => "80",
          "statisticalIndicator" => "2",
          "validityStartDate" => "2017-10-01T00:00:00",
          "validityEndDate" => "2020-09-01T00:00:00",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-09-27T07:26:25"
          }
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-08-21T17:21:35"
        }
      }
      subject = CdsImporter::EntityMapper::ExportRefundNomenclatureIndentMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(ExportRefundNomenclatureIndent)
      expect(entity.export_refund_nomenclature_indents_sid).to eq(values["exportRefundNomenclatureIndents"]["sid"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclature"]["goodsNomenclatureItemId"])
      expect(entity.number_export_refund_nomenclature_indents).to eq(values["exportRefundNomenclatureIndents"]["numberExportRefundNomenclatureIndents"])
      expect(entity.additional_code_type).to eq(values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.export_refund_code).to eq(values["exportRefundCode"])
      expect(entity.productline_suffix).to eq(values["productLine"])
      expect(entity.operation_date).to eq(Date.parse(values["exportRefundNomenclatureIndents"]["metainfo"]["transactionDate"]))
      expect(entity.operation).to eq(:create)
      expect(entity.validity_start_date).to eq(Date.parse(values["exportRefundNomenclatureIndents"]["validityStartDate"]))
      expect(entity.validity_end_date).to eq(Date.parse(values["exportRefundNomenclatureIndents"]["validityEndDate"]))
    end

    it "ExportRefundNomenclatureDescriptionPeriod sample" do
      values = {
        "sid" => 1233,
        "exportRefundCode" => "700",
        "productLine" => "80",
        "exportRefundNomenclatureDescriptionPeriod" => {
          "sid" => 1126,
          "validityStartDate" => "2014-06-12T00:00:00",
          "validityEndDate" => "2019-05-02T00:00:00",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-07-22T15:22:15"
          }
        },
        "additionalCodeType" => {
          "additionalCodeTypeId" => "8"
        },
        "goodsNomenclature" => {
          "sid" => 1234,
          "goodsNomenclatureItemId" => "9950000000",
          "produclineSuffix" => "80",
          "statisticalIndicator" => "2",
          "validityStartDate" => "2017-10-01T00:00:00",
          "validityEndDate" => "2020-09-01T00:00:00",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-09-27T07:26:25"
          }
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-08-21T17:21:35"
        }
      }
      subject = CdsImporter::EntityMapper::ExportRefundNomenclatureDescriptionPeriodMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(ExportRefundNomenclatureDescriptionPeriod)
      expect(entity.export_refund_nomenclature_description_period_sid).to eq(values["exportRefundNomenclatureDescriptionPeriod"]["sid"])
      expect(entity.export_refund_nomenclature_sid).to eq(values["sid"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclature"]["goodsNomenclatureItemId"])
      expect(entity.additional_code_type).to eq(values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.export_refund_code).to eq(values["exportRefundCode"])
      expect(entity.productline_suffix).to eq(values["productLine"])
      expect(entity.operation_date).to eq(Date.parse(values["exportRefundNomenclatureDescriptionPeriod"]["metainfo"]["transactionDate"]))
      expect(entity.operation).to eq(:update)
      expect(entity.validity_start_date).to eq(Date.parse(values["exportRefundNomenclatureDescriptionPeriod"]["validityStartDate"]))
      expect(entity.validity_end_date).to eq(Date.parse(values["exportRefundNomenclatureDescriptionPeriod"]["validityEndDate"]))
    end

    it "ExportRefundNomenclatureDescriptionPeriod sample" do
      values = {
        "sid" => 1114,
        "exportRefundCode" => "700",
        "productLine" => "80",
        "exportRefundNomenclatureDescriptionPeriod" => {
          "sid" => 4211,
          "validityStartDate" => "2015-06-17T00:00:00",
          "validityEndDate" => "2019-06-02T00:00:00",
          "exportRefundNomenclatureDescription" => {
            "description" => "Some description",
            "language" => {
              "languageId" => "EN"
            },
            "metainfo" => {
              "opType" => "C",
              "transactionDate" => "2017-09-25T10:21:15"
            }
          },
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-07-22T15:22:15"
          }
        },
        "additionalCodeType" => {
          "additionalCodeTypeId" => "8"
        },
        "goodsNomenclature" => {
          "sid" => 1234,
          "goodsNomenclatureItemId" => "9950000000",
          "produclineSuffix" => "80",
          "statisticalIndicator" => "2",
          "validityStartDate" => "2017-10-01T00:00:00",
          "validityEndDate" => "2020-09-01T00:00:00",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-09-27T07:26:25"
          }
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-08-21T17:21:35"
        }
      }
      subject = CdsImporter::EntityMapper::ExportRefundNomenclatureDescriptionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(ExportRefundNomenclatureDescription)
      expect(entity.export_refund_nomenclature_description_period_sid).to eq(values["exportRefundNomenclatureDescriptionPeriod"]["sid"])
      expect(entity.export_refund_nomenclature_sid).to eq(values["sid"])
      expect(entity.language_id).to eq(values["exportRefundNomenclatureDescriptionPeriod"]["exportRefundNomenclatureDescription"]["language"]["languageId"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclature"]["goodsNomenclatureItemId"])
      expect(entity.additional_code_type).to eq(values["additionalCodeType"]["additionalCodeTypeId"])
      expect(entity.export_refund_code).to eq(values["exportRefundCode"])
      expect(entity.productline_suffix).to eq(values["productLine"])
      expect(entity.operation_date).to eq(Date.parse(values["exportRefundNomenclatureDescriptionPeriod"]["exportRefundNomenclatureDescription"]["metainfo"]["transactionDate"]))
      expect(entity.operation).to eq(:create)
    end

    it "DutyExpression sample" do
      values = {
        "dutyExpressionId" => "14",
        "validityEndDate" => "1995-06-30T23:59:59",
        "validityStartDate" => "1972-01-01T00:00:00",
        "dutyAmountApplicabilityCode" => 2,
        "measurementUnitApplicabilityCode" => 0,
        "monetaryUnitApplicabilityCode" => 0,
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2016-07-27T09:20:10"
        }
      }
      subject = CdsImporter::EntityMapper::DutyExpressionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(DutyExpression)
      expect(entity.duty_expression_id).to eq(values["dutyExpressionId"])
      expect(entity.validity_end_date).to eq(values["validityEndDate"])
      expect(entity.validity_start_date).to eq(values["validityStartDate"])
      expect(entity.duty_amount_applicability_code).to eq(values["dutyAmountApplicabilityCode"])
      expect(entity.measurement_unit_applicability_code).to eq(values["measurementUnitApplicabilityCode"])
      expect(entity.monetary_unit_applicability_code).to eq(values["monetaryUnitApplicabilityCode"])
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end

    it "Footnote sample" do
      values = {
        "footnoteId" => "133",
        "validityStartDate" => "1972-01-01T00:00:00",
        "validityEndDate" => "1973-01-01T00:00:00",
        "footnoteType" => {
          "footnoteTypeId" => "TM"
        },
        "metainfo" => {
          "opType" => "U",
          "origin" => "T",
          "transactionDate" => "2016-07-27T09:18:57"
        }
      }
      subject = CdsImporter::EntityMapper::FootnoteMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(Footnote)
      expect(entity.footnote_id).to eq(values["footnoteId"])
      expect(entity.footnote_type_id).to eq(values["footnoteType"]["footnoteTypeId"])
      expect(entity.validity_start_date).to eq(values["validityStartDate"])
      expect(entity.validity_end_date).to eq(values["validityEndDate"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end

    it "FootnoteAssociationGoodsNomenclature sample" do
      values = {
        "sid" => 27652,
        "produclineSuffix" => "80",
        "goodsNomenclatureItemId" => "0102903131",
        "footnoteAssociationGoodsNomenclature" => {
          "validityEndDate" => "1992-12-31T23:59:59",
          "validityStartDate" => "1991-01-01T00:00:00",
          "footnote" => {
            "footnoteId" => "001"
          },
          "metainfo" => {
            "opType" => "C",
            "origin" => "T",
            "transactionDate" => "2016-07-25T11:07:56"
          }
        }
      }
      subject = CdsImporter::EntityMapper::FootnoteAssociationGoodsNomenclatureMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FootnoteAssociationGoodsNomenclature)
      expect(entity.goods_nomenclature_sid).to eq(values["sid"])
      expect(entity.footnote_id).to eq(values["footnoteAssociationGoodsNomenclature"]["footnote"]["footnoteId"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
      expect(entity.productline_suffix).to eq(values["produclineSuffix"])
      expect(entity.validity_start_date).to eq(values["footnoteAssociationGoodsNomenclature"]["validityStartDate"])
      expect(entity.validity_end_date).to eq(values["footnoteAssociationGoodsNomenclature"]["validityEndDate"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["footnoteAssociationGoodsNomenclature"]["metainfo"]["transactionDate"]))
    end

    it "FootnoteDescription sample" do
      values = {
        "footnoteId" => "133",
        "footnoteType" => {
          "footnoteTypeId" => "TM"
        },
        "footnoteDescriptionPeriod" => {
          "footnoteDescriptionPeriodSid" => 1355,
          "footnoteDescription" => {
            "description" => "The rate of duty is applicable to the net free-at-Community",
            "language" => {
              "languageId" => "EN"
            },
            "metainfo" => {
              "origin" => "T",
              "opType" => "C",
              "transactionDate" => "2016-07-27T09:18:57"
            }
          }
        }
      }
      subject = CdsImporter::EntityMapper::FootnoteDescriptionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FootnoteDescription)
      expect(entity.footnote_description_period_sid).to eq(values["footnoteDescriptionPeriod"]["footnoteDescriptionPeriodSid"])
      expect(entity.footnote_type_id).to eq(values["footnoteType"]["footnoteTypeId"])
      expect(entity.footnote_id).to eq(values["footnoteId"])
      expect(entity.language_id).to eq(values["footnoteDescriptionPeriod"]["footnoteDescription"]["language"]["languageId"])
      expect(entity.description).to eq(values["footnoteDescriptionPeriod"]["footnoteDescription"]["description"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["footnoteDescriptionPeriod"]["footnoteDescription"]["metainfo"]["transactionDate"]))
    end

    it "FootnoteDescriptionPeriod sample" do
      values = {
        "footnoteType" => {
          "footnoteTypeId" => "TM"
        },
        "footnoteDescriptionPeriod" => {
          "sid" => 1355,
          "validityStartDate" => "1972-01-01T00:00:00",
          "validityEndDate" => "1973-01-01T00:00:00",
          "metainfo" => {
            "opType" => "C",
            "origin" => "T",
            "transactionDate" => "2016-07-27T09:18:57"
          }
        }
      }
      subject = CdsImporter::EntityMapper::FootnoteDescriptionPeriodMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FootnoteDescriptionPeriod)
      expect(entity.footnote_description_period_sid).to eq(values["footnoteDescriptionPeriod"]["sid"])
      expect(entity.footnote_type_id).to eq(values["footnoteType"]["footnoteTypeId"])
      expect(entity.validity_start_date).to eq(values["footnoteDescriptionPeriod"]["validityStartDate"])
      expect(entity.validity_end_date).to eq(values["footnoteDescriptionPeriod"]["validityEndDate"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["footnoteDescriptionPeriod"]["metainfo"]["transactionDate"]))
    end

    it "FootnoteType sample" do
      values = {
        "footnoteTypeId" => "TN",
        "applicationCode" => 2,
        "metainfo" => {
          "opType" => "C",
          "origin" => "T",
          "transactionDate" => "2016-07-27T09:18:51"
        }
      }
      subject = CdsImporter::EntityMapper::FootnoteTypeMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FootnoteType)
      expect(entity.footnote_type_id).to eq(values["footnoteTypeId"])
      expect(entity.application_code).to eq(values["applicationCode"])
      expect(entity.validity_start_date).to eq(values["validityStartDate"])
      expect(entity.validity_end_date).to eq(values["validityEndDate"])
      expect(entity.national).to be_falsey
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end
  end
end
