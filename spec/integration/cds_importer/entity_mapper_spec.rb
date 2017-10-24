require "rails_helper"
require "cds_importer/entity_mapper"

describe CdsImporter::EntityMapper do
  describe "#process!" do
    it "additional code sample" do
      # allow setting primary keys
      Sequel::Model.subclasses.each(&:unrestrict_primary_key)
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
  end
end
