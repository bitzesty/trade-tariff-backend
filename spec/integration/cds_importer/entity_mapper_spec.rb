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
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))

    end

    it "GoodsNomenclatureDescription sample" do
      values = {
        "sid" => 1234,
        "goodsNomenclatureItemId" => "9950000000",
        "produclineSuffix" => "80",
        "statisticalIndicator" => "2",
        "validityStartDate" => "2017-10-01T00:00:00",
        "validityEndDate" => "2020-09-01T00:00:00",
        "goodsNomenclatureDescriptionPeriod" => {
          "sid" => 1155,
          "goodsNomenclatureDescription" => {
            "description" => "Some description.",
            "language" => {
              "languageId" => "EN"
            },
            "metainfo" => {
              "opType" => "U",
              "transactionDate" => "2017-08-24T04:21:16"
            }
          }
        },
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2017-09-28T09:23:15"
        }
      }
      subject = CdsImporter::EntityMapper::GoodsNomenclatureDescriptionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(GoodsNomenclatureDescription)
      expect(entity.goods_nomenclature_description_period_sid).to eq(values["goodsNomenclatureDescriptionPeriod"]["sid"])
      expect(entity.goods_nomenclature_sid).to eq(values["sid"])
      expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
      expect(entity.productline_suffix).to eq(values["produclineSuffix"])
      expect(entity.description).to eq(values["goodsNomenclatureDescriptionPeriod"]["goodsNomenclatureDescription"]["description"])
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureDescriptionPeriod"]["goodsNomenclatureDescription"]["metainfo"]["transactionDate"]))
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
        "approvedFlag" => "0",
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
      expect(entity.approved_flag).to eq(false)
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
        "approvedFlag" => "1",
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
      expect(entity.approved_flag).to eq(true)
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

    it "FtsRegulationAction sample" do
      values = {
        "sid" => 1277,
        "approvedFlag" => "1",
        "fullTemporaryStopRegulationId" => "11122",
        "regulationRoleType" => {
          "regulationRoleTypeId" => "6"
        },
        "ftsRegulationAction" => {
          "sid" => 1127,
          "stoppedRegulationId" => "112233",
          "stoppedRegulationRole" => "5",
          "metainfo" => {
            "opType" => "U",
            "transactionDate" => "2017-07-27T19:18:31"
          }
        },
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2016-07-27T09:18:51"
        }
      }
      subject = CdsImporter::EntityMapper::FtsRegulationActionMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FtsRegulationAction)
      expect(entity.fts_regulation_role.to_s).to eq(values["regulationRoleType"]["regulationRoleTypeId"])
      expect(entity.fts_regulation_id).to eq(values["fullTemporaryStopRegulationId"])
      expect(entity.stopped_regulation_role.to_s).to eq(values["ftsRegulationAction"]["stoppedRegulationRole"])
      expect(entity.stopped_regulation_id).to eq(values["ftsRegulationAction"]["stoppedRegulationId"])
      expect(entity.operation).to eq(:update)
      expect(entity.operation_date).to eq(Date.parse(values["ftsRegulationAction"]["metainfo"]["transactionDate"]))
    end

    it "FtsRegulationAction sample" do
      values = {
        "sid" => 1277,
        "approvedFlag" => "1",
        "fullTemporaryStopRegulationId" => "22113",
        "publishedDate" => "2017-08-25T07:41:22",
        "effectiveEndDate" => "2018-08-20T09:42:12",
        "officialjournalNumber" => "K 320",
        "officialjournalPage" => "12",
        "replacementIndicator" => "2",
        "informationText" => "ER",
        "explicitAbrogationRegulation" => {
          "explicitAbrogationRegulationId" => "11226",
          "regulationRoleType" => {
            "regulationRoleTypeId" => "7"
          },
        },
        "regulationRoleType" => {
          "regulationRoleTypeId" => "6"
        },
        "ftsRegulationAction" => {
          "sid" => 1127
        },
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2016-07-27T09:18:51"
        }
      }
      subject = CdsImporter::EntityMapper::FullTemporaryStopRegulationMapper.new(values)
      entity = subject.parse
      expect(entity).to be_a(FullTemporaryStopRegulation)
      expect(entity.full_temporary_stop_regulation_role.to_s).to eq(values["regulationRoleType"]["regulationRoleTypeId"])
      expect(entity.full_temporary_stop_regulation_id).to eq(values["fullTemporaryStopRegulationId"])
      expect(entity.explicit_abrogation_regulation_role.to_s).to eq(values["explicitAbrogationRegulation"]["regulationRoleType"]["regulationRoleTypeId"])
      expect(entity.explicit_abrogation_regulation_id).to eq(values["explicitAbrogationRegulation"]["explicitAbrogationRegulationId"])
      expect(entity.published_date).to eq(Date.parse(values["publishedDate"]))
      expect(entity.effective_enddate).to eq(Date.parse(values["effectiveEndDate"]))
      expect(entity.officialjournal_number).to eq(values["officialjournalNumber"])
      expect(entity.officialjournal_page.to_s).to eq(values["officialjournalPage"])
      expect(entity.replacement_indicator.to_s).to eq(values["replacementIndicator"])
      expect(entity.information_text).to eq(values["informationText"])
      expect(entity.approved_flag).to eq(true)
      expect(entity.operation).to eq(:create)
      expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
    end
  end

  it "FootnoteTypeDescription sample" do
    values = {
      "footnoteTypeId" => "TN",
      "footnoteTypeDescription" => {
        "description" => "Taric Nomenclature",
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "C",
          "origin" => "T",
          "transactionDate" => "2016-07-27T09:18:51"
        }
      }
    }
    subject = CdsImporter::EntityMapper::FootnoteTypeDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(FootnoteTypeDescription)
    expect(entity.footnote_type_id).to eq(values["footnoteTypeId"])
    expect(entity.language_id).to eq(values["footnoteTypeDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["footnoteTypeDescription"]["description"])
    expect(entity.national).to be_falsey
    expect(entity.operation).to eq(:create)
    expect(entity.operation_date).to eq(Date.parse(values["footnoteTypeDescription"]["metainfo"]["transactionDate"]))
  end

  it "GeographicalArea sample" do
    values = {
      "sid" => 234,
      "validityStartDate" => "1984-01-01T00:00:00",
      "geographicalCode" => "1",
      "geographicalAreaId" => "1032",
      "metainfo" => {
        "opType" => "U",
        "origin" => "N",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::GeographicalAreaMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GeographicalArea)
    expect(entity.geographical_area_sid).to eq(values["sid"])
    expect(entity.geographical_code).to eq(values["geographicalCode"])
    expect(entity.geographical_area_id).to eq(values["geographicalAreaId"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "GeographicalAreaDescription sample" do
    values = {
      "sid" => 234,
      "geographicalAreaId" => "1032",
      "geographicalAreaDescriptionPeriod" => {
        "sid" => 1239,
        "geographicalAreaDescription" => {
          "description" => "Economic Partnership Agreements",
          "language" => {
            "languageId" => "EN"
          },
          "metainfo" => {
            "opType" => "U",
            "origin" => "N",
            "transactionDate" => "2016-07-27T09:21:40"
          }
        }
      }
    }
    subject = CdsImporter::EntityMapper::GeographicalAreaDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GeographicalAreaDescription)
    expect(entity.geographical_area_description_period_sid).to eq(values["geographicalAreaDescriptionPeriod"]["sid"])
    expect(entity.language_id).to eq(values["geographicalAreaDescriptionPeriod"]["geographicalAreaDescription"]["language"]["languageId"])
    expect(entity.geographical_area_sid).to eq(values["sid"])
    expect(entity.geographical_area_id).to eq(values["geographicalAreaId"])
    expect(entity.description).to eq(values["geographicalAreaDescriptionPeriod"]["geographicalAreaDescription"]["description"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["geographicalAreaDescriptionPeriod"]["geographicalAreaDescription"]["metainfo"]["transactionDate"]))
  end

  it "GeographicalAreaDescriptionPeriod sample" do
    values = {
      "sid" => 234,
      "geographicalAreaId" => "1032",
      "geographicalAreaDescriptionPeriod" => {
        "sid" => 1239,
        "validityStartDate" => "2008-01-01T00:00:00",
        "metainfo" => {
          "opType" => "U",
          "origin" => "N",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GeographicalAreaDescriptionPeriodMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GeographicalAreaDescriptionPeriod)
    expect(entity.geographical_area_description_period_sid).to eq(values["geographicalAreaDescriptionPeriod"]["sid"])
    expect(entity.geographical_area_sid).to eq(values["sid"])
    expect(entity.validity_start_date).to eq(values["geographicalAreaDescriptionPeriod"]["validityStartDate"])
    expect(entity.geographical_area_id).to eq(values["geographicalAreaId"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["geographicalAreaDescriptionPeriod"]["metainfo"]["transactionDate"]))
  end

  it "GeographicalAreaMembership sample" do
    values = {
      "sid" => 234,
      "geographicalAreaMembership" => {
        "geographicalAreaGroupSid" => 461273,
        "validityStartDate" => "2008-01-01T00:00:00",
        "metainfo" => {
          "opType" => "U",
          "origin" => "N",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GeographicalAreaMembershipMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GeographicalAreaMembership)
    expect(entity.geographical_area_sid).to eq(values["sid"])
    expect(entity.geographical_area_group_sid).to eq(values["geographicalAreaMembership"]["geographicalAreaGroupSid"])
    expect(entity.validity_start_date).to eq(values["geographicalAreaMembership"]["validityStartDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.national).to be_truthy
    expect(entity.operation_date).to eq(Date.parse(values["geographicalAreaMembership"]["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureGroup sample" do
    values = {
      "goodsNomenclatureGroupId" => "125000",
      "goodsNomenclatureGroupType" => "T",
      "nomenclatureGroupFacilityCode" => "123",
      "validityEndDate" => "2019-12-31T23:59:59",
      "validityStartDate" => "1991-01-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureGroupMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureGroup)
    expect(entity.goods_nomenclature_group_type).to eq(values["goodsNomenclatureGroupType"])
    expect(entity.goods_nomenclature_group_id).to eq(values["goodsNomenclatureGroupId"])
    expect(entity.nomenclature_group_facility_code.to_s).to eq(values["nomenclatureGroupFacilityCode"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.validity_end_date).to eq(values["validityEndDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureGroupDescription sample" do
    values = {
      "goodsNomenclatureGroupId" => "125000",
      "goodsNomenclatureGroupType" => "T",
      "goodsNomenclatureGroupDescription" => {
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureGroupDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureGroupDescription)
    expect(entity.goods_nomenclature_group_type).to eq(values["goodsNomenclatureGroupType"])
    expect(entity.goods_nomenclature_group_id).to eq(values["goodsNomenclatureGroupId"])
    expect(entity.language_id).to eq(values["goodsNomenclatureGroupDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["goodsNomenclatureGroupDescription"]["description"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureGroupDescription"]["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureIndent sample" do
    values = {
      "sid" => 27652,
      "goodsNomenclatureItemId" => "0102901019",
      "produclineSuffix" => "80",
      "goodsNomenclatureIndents" => {
        "sid" => 28131,
        "validityStartDate" => "1992-03-01T00:00:00",
        "numberIndents" => 5,
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureIndentMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureIndent)
    expect(entity.goods_nomenclature_indent_sid).to eq(values["goodsNomenclatureIndents"]["sid"])
    expect(entity.goods_nomenclature_sid).to eq(values["sid"])
    expect(entity.validity_start_date).to eq(values["goodsNomenclatureIndents"]["validityStartDate"])
    expect(entity.number_indents).to eq(values["goodsNomenclatureIndents"]["numberIndents"])
    expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
    expect(entity.productline_suffix).to eq(values["produclineSuffix"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureIndents"]["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureOrigin sample" do
    values = {
      "sid" => 27652,
      "produclineSuffix" => "80",
      "goodsNomenclatureItemId" => "0102901019",
      "goodsNomenclatureOrigin" => {
        "derivedGoodsNomenclatureItemId" => "0100000000",
        "derivedProductlineSuffix" => "80",
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureOriginMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureOrigin)
    expect(entity.goods_nomenclature_sid).to eq(values["sid"])
    expect(entity.derived_goods_nomenclature_item_id).to eq(values["goodsNomenclatureOrigin"]["derivedGoodsNomenclatureItemId"])
    expect(entity.derived_productline_suffix).to eq(values["goodsNomenclatureOrigin"]["derivedProductlineSuffix"])
    expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
    expect(entity.productline_suffix).to eq(values["produclineSuffix"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureOrigin"]["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureSuccessor sample" do
    values = {
      "sid" => 27652,
      "goodsNomenclatureItemId" => "0102903131",
      "produclineSuffix" => "10",
      "goodsNomenclatureSuccessor" => {
        "absorbedGoodsNomenclatureItemId" => "0101901100",
        "absorbedProductlineSuffix" => "80",
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureSuccessorMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureSuccessor)
    expect(entity.goods_nomenclature_sid).to eq(values["sid"])
    expect(entity.absorbed_goods_nomenclature_item_id).to eq(values["goodsNomenclatureSuccessor"]["absorbedGoodsNomenclatureItemId"])
    expect(entity.absorbed_productline_suffix).to eq(values["goodsNomenclatureSuccessor"]["absorbedProductlineSuffix"])
    expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
    expect(entity.productline_suffix).to eq(values["produclineSuffix"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureSuccessor"]["metainfo"]["transactionDate"]))
  end

  it "Language sample" do
    values = {
      "languageId" => "EN",
      "validityStartDate" => "1992-03-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::LanguageMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(Language)
    expect(entity.language_id).to eq(values["languageId"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "LanguageDescription sample" do
    values = {
      "languageId" => "EN",
      "languageDescription" => {
        "description" => "English",
        "metainfo" => {
          "opType" => "C",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::LanguageDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(LanguageDescription)
    expect(entity.language_id).to eq(values["languageId"])
    expect(entity.description).to eq(values["languageDescription"]["description"])
    expect(entity.operation).to eq(:create)
    expect(entity.operation_date).to eq(Date.parse(values["languageDescription"]["metainfo"]["transactionDate"]))
  end

  it "GoodsNomenclatureDescriptionPeriod sample" do
    values = {
      "sid" => 27652,
      "goodsNomenclatureItemId" => "0102901019",
      "produclineSuffix" => "80",
      "goodsNomenclatureDescriptionPeriod" => {
        "sid" => 30993,
        "validityStartDate" => "1992-03-01T00:00:00",
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::GoodsNomenclatureDescriptionPeriodMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(GoodsNomenclatureDescriptionPeriod)
    expect(entity.goods_nomenclature_description_period_sid).to eq(values["goodsNomenclatureDescriptionPeriod"]["sid"])
    expect(entity.goods_nomenclature_sid).to eq(values["sid"])
    expect(entity.validity_start_date).to eq(values["goodsNomenclatureDescriptionPeriod"]["validityStartDate"])
    expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
    expect(entity.productline_suffix).to eq(values["produclineSuffix"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["goodsNomenclatureDescriptionPeriod"]["metainfo"]["transactionDate"]))
  end

  it "MeasureAction sample" do
    values = {
      "actionCode" => "29",
      "validityStartDate" => "1970-01-01T00:00:00",
      "validityEndDate" => "1972-01-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::MeasureActionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(MeasureAction)
    expect(entity.action_code).to eq(values["actionCode"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.validity_end_date).to eq(values["validityEndDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "MeasureActionDescription sample" do
    values = {
      "actionCode" => "29",
      "measureActionDescription" => {
        "description" => "Import/export allowed after control",
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::MeasureActionDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(MeasureActionDescription)
    expect(entity.action_code).to eq(values["actionCode"])
    expect(entity.language_id).to eq(values["measureActionDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["measureActionDescription"]["description"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["measureActionDescription"]["metainfo"]["transactionDate"]))
  end

  it "RegulationGroup sample" do
    values = {
      "hjid" => "440103",
      "regulationGroupId" => "123",
      "validityStartDate" => "1970-01-01T00:00:00",
      "validityEndDate" => "1972-01-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "origin" => "T",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::RegulationGroupMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(RegulationGroup)
    expect(entity.regulation_group_id).to eq(values["regulationGroupId"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.validity_end_date).to eq(values["validityEndDate"])
    expect(entity.national).to be_falsey
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "RegulationGroupDescription sample" do
    values = {
      "hjid" => "440103",
      "regulationGroupId" => "123",
      "regulationGroupDescription" => {
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "U",
          "origin" => "N",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::RegulationGroupDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(RegulationGroupDescription)
    expect(entity.regulation_group_id).to eq(values["regulationGroupId"])
    expect(entity.language_id).to eq(values["regulationGroupDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["regulationGroupDescription"]["description"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["regulationGroupDescription"]["metainfo"]["transactionDate"]))
  end

  it "RegulationReplacement sample" do
    values = {
      "replacedRegulationRole" => 1,
      "replacingRegulationRole" => 1,
      "replacedRegulationId" => "C9600110",
      "replacingRegulationId" => "R9608580",
      "geographicalArea" => {
        "geographicalAreaId" => "1011"
      },
      "measureType" => {
        "measureTypeId" => "2"
      },
      "chapterHeading" => "123",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::RegulationReplacementMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(RegulationReplacement)
    expect(entity.geographical_area_id).to eq(values["geographicalArea"]["geographicalAreaId"])
    expect(entity.replacing_regulation_role).to eq(values["replacingRegulationRole"])
    expect(entity.replacing_regulation_id).to eq(values["replacingRegulationId"])
    expect(entity.replaced_regulation_role).to eq(values["replacedRegulationRole"])
    expect(entity.replaced_regulation_id).to eq(values["replacedRegulationId"])
    expect(entity.chapter_heading).to eq(values["chapterHeading"])
    expect(entity.measure_type_id).to eq(values["measureType"]["measureTypeId"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "RegulationRoleType sample" do
    values = {
      "regulationRoleTypeId" => 1,
      "validityStartDate" => "1970-01-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "origin" => "N",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::RegulationRoleTypeMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(RegulationRoleType)
    expect(entity.regulation_role_type_id).to eq(values["regulationRoleTypeId"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "RegulationRoleTypeDescription sample" do
    values = {
      "regulationRoleTypeId" => "1",
      "regulationRoleTypeDescription" => {
        "description" => "Base regulation",
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "U",
          "origin" => "N",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::RegulationRoleTypeDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(RegulationRoleTypeDescription)
    expect(entity.regulation_role_type_id).to eq(values["regulationRoleTypeId"])
    expect(entity.language_id).to eq(values["regulationRoleTypeDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["regulationRoleTypeDescription"]["description"])
    expect(entity.national).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["regulationRoleTypeDescription"]["metainfo"]["transactionDate"]))
  end

  it "MonetaryUnit sample" do
    values = {
      "monetaryUnitCode" => "IEP",
      "validityStartDate" => "1970-01-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::MonetaryUnitMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(MonetaryUnit)
    expect(entity.monetary_unit_code).to eq(values["monetaryUnitCode"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "MonetaryUnitDescription sample" do
    values = {
      "monetaryUnitCode" => "IEP",
      "monetaryUnitDescription" => {
        "description" => "Irish pound",
        "language" => {
          "languageId" => "EN"
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::MonetaryUnitDescriptionMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(MonetaryUnitDescription)
    expect(entity.monetary_unit_code).to eq(values["monetaryUnitCode"])
    expect(entity.language_id).to eq(values["monetaryUnitDescription"]["language"]["languageId"])
    expect(entity.description).to eq(values["monetaryUnitDescription"]["description"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["monetaryUnitDescription"]["metainfo"]["transactionDate"]))
  end

  it "NomenclatureGroupMembership sample" do
    values = {
      "sid" => 27640,
      "produclineSuffix" => "80",
      "goodsNomenclatureItemId" => "0102900500",
      "nomenclatureGroupMembership" => {
        "goodsNomenclatureGroup" => {
          "goodsNomenclatureGroupId" => "010000",
          "goodsNomenclatureGroupType" => "B"
        },
        "metainfo" => {
          "opType" => "U",
          "transactionDate" => "2017-06-29T20:04:37"
        }
      }
    }
    subject = CdsImporter::EntityMapper::NomenclatureGroupMembershipMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(NomenclatureGroupMembership)
    expect(entity.goods_nomenclature_sid).to eq(values["sid"])
    expect(entity.goods_nomenclature_group_type).to eq(values["nomenclatureGroupMembership"]["goodsNomenclatureGroup"]["goodsNomenclatureGroupType"])
    expect(entity.goods_nomenclature_group_id).to eq(values["nomenclatureGroupMembership"]["goodsNomenclatureGroup"]["goodsNomenclatureGroupId"])
    expect(entity.validity_start_date).to eq(values["nomenclatureGroupMembership"]["validityStartDate"])
    expect(entity.goods_nomenclature_item_id).to eq(values["goodsNomenclatureItemId"])
    expect(entity.productline_suffix).to eq(values["produclineSuffix"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["nomenclatureGroupMembership"]["metainfo"]["transactionDate"]))
  end

  it "MonetaryExchangePeriod sample" do
    values = {
      "sid" => 2927,
      "validityStartDate" => "2015-03-01T00:00:00",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::MonetaryExchangePeriodMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(MonetaryExchangePeriod)
    expect(entity.monetary_exchange_period_sid).to eq(values["sid"])
    expect(entity.validity_start_date).to eq(values["validityStartDate"])
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end

  it "ProrogationRegulation sample" do
    values = {
      "approvedFlag" => "1",
      "publishedDate" => "1998-04-01T00:00:00",
      "informationText" => "474 LPQ-TEXT-RU",
      "officialjournalPage" => 52,
      "replacementIndicator" => 0,
      "officialjournalNumber" => "L 100",
      "prorogationRegulationId" => "R9807290",
      "metainfo" => {
        "opType" => "U",
        "transactionDate" => "2017-06-29T20:04:37"
      }
    }
    subject = CdsImporter::EntityMapper::ProrogationRegulationMapper.new(values)
    entity = subject.parse
    expect(entity).to be_a(ProrogationRegulation)
    expect(entity.prorogation_regulation_id).to eq(values["prorogationRegulationId"])
    expect(entity.published_date).to eq(Date.parse(values["publishedDate"]))
    expect(entity.officialjournal_number).to eq(values["officialjournalNumber"])
    expect(entity.officialjournal_page).to eq(values["officialjournalPage"])
    expect(entity.replacement_indicator).to eq(values["replacementIndicator"])
    expect(entity.information_text).to eq(values["informationText"])
    expect(entity.approved_flag).to be_truthy
    expect(entity.operation).to eq(:update)
    expect(entity.operation_date).to eq(Date.parse(values["metainfo"]["transactionDate"]))
  end
end
