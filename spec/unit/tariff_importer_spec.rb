require 'spec_helper'

require 'tariff_importer'

describe TariffImporter do
  let(:valid_file)       { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }
  let(:invalid_file)     { "err" }
  let(:valid_importer)   { "ChiefImporter" }
  let(:invalid_importer) { "Err" }

  describe "initialization" do
    it 'sets path on initialization' do
      -> { TariffImporter.new(valid_file, ChiefImporter) }.should_not raise_error
    end

    it 'throws an error if path is non existent' do
      -> { TariffImporter.new(invalid_file) }.should raise_error
    end

    it 'initializes only valid importers' do
      -> { TariffImporter.new(valid_file, valid_importer) }.should_not raise_error
      -> { TariffImporter.new(valid_file, invalid_importer) }.should raise_error
    end
  end

  describe "importing" do
    class MockImporter
      def initialize(abc)
      end
    end

    context 'file is present' do
      let(:importer) { TariffImporter.new(valid_file, "MockImporter") }

      it 'delegates import to importer' do
        MockImporter.any_instance.expects(:import)

        importer.import
      end
    end

    context 'file is not present' do
      let(:importer) { TariffImporter.new('non-existent-file', "MockImporter") }

      it 'raises NotFound exception' do
        expect { importer.import }.to raise_error TariffImporter::NotFound
      end
    end
  end
end
