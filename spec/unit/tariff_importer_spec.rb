require 'rails_helper'

require 'tariff_importer'

describe TariffImporter do
  let(:valid_file)       { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }
  let(:invalid_file)     { "err" }
  let(:valid_importer)   { "ChiefImporter" }
  let(:invalid_importer) { "Err" }

  describe "initialization" do
    it 'sets path on initialization' do
      expect(
        -> { TariffImporter.new(valid_file, ChiefImporter) }
      ).to_not raise_error
    end

    it 'throws an error if path is non existent' do
      expect(
        -> { TariffImporter.new(invalid_file) }
      ).to raise_error
    end
  end
end
