require "rails_helper"
require "fileutils"

describe CdsImporter do
  let(:cds_update) { TariffSynchronizer::CdsUpdate.new(filename: "filename.xml") }
  let(:importer) { CdsImporter.new(cds_update) }

  before(:all) do
    FileUtils.mkpath("tmp/data/cds")
    FileUtils.touch("tmp/data/cds/filename.xml")
  end

  describe "#import" do
    it "should create new instance of XmlProcessor" do
      expect(CdsImporter::XmlProcessor).to receive(:new).and_call_original
      importer.import
    end

    it "should invoke CdsImporter::XmlParser::Reader" do
      expect_any_instance_of(CdsImporter::XmlParser::Reader).to receive(:parse)
      importer.import
    end
  end

  describe "XmlProcessor" do
    let(:processor) { CdsImporter::XmlProcessor.new }

    it "should invoke EntityMapper" do
      expect_any_instance_of(CdsImporter::EntityMapper).to receive(:import)
      processor.process_xml_node("AdditionalCode", {})
    end

    context "when some error appears" do
      before do
        allow_any_instance_of(CdsImporter::EntityMapper).to receive(:import).and_raise(StandardError)
      end

      it "should raise ImportException" do
        expect{ processor.process_xml_node("AdditionalCode", {}) }.to raise_error(CdsImporter::ImportException)
      end
    end
  end
end
