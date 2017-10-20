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
          sid: 3084,
          additionalCodeCode: "169"
        }
      )
      subject = described_class.new(hash_double)
      entity = subject.parse
      expect(entity.additional_code_sid).to eq(hash_double.values[:sid])
      expect(entity.additional_code).to eq(hash_double.values[:additionalCodeCode])
    end
  end
end
