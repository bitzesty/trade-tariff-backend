require "rails_helper"

describe CdsImporter::EntityMapper do
  let(:xml_node) {
    {
      "sid" => "3084",
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
  }
  let(:mapper) { described_class.new("AdditionalCode", xml_node) }

  before :all do
   CdsImporter::EntityMapper::ALL_MAPPERS = [CdsImporter::EntityMapper::AdditionalCodeMapper]
  end

  describe "#import" do
    context "when cds logger enabled" do
      before do
        allow(TariffSynchronizer).to receive(:cds_logger_enabled).and_return(true)
      end

      it "should call safe method" do
        expect(mapper).to receive(:save_record)
        mapper.import
      end
    end
    
    context "when cds logger disabled" do
      it "should call bang method" do
        expect(mapper).to receive(:save_record!)
        mapper.import
      end

      it "should raise an error and stop import" do
        allow_any_instance_of(AdditionalCode).to receive(:save).and_raise(StandardError)
        expect{ mapper.import }.to raise_error(StandardError)
      end
    end

    it "should call save method for any instance" do
      expect_any_instance_of(AdditionalCode).to receive(:save).with({ validate: false, transaction: false })
      mapper.import
    end

    it "should select mappers by mapping root" do
      expect_any_instance_of(CdsImporter::EntityMapper::AdditionalCodeMapper).to receive(:parse).and_call_original
      mapper.import
    end
  end
end
