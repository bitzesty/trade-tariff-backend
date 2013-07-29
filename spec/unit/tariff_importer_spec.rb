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
  end
end
