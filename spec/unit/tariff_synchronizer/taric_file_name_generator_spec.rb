require 'rails_helper'
require 'tariff_synchronizer/taric_file_name_generator'

describe TaricFileNameGenerator do
  let(:example_date){ Date.new(2010,1,1) }
  let(:taric_file_name_generator) { TaricFileNameGenerator.new(example_date) }

  describe "#url" do
    it "returns the expected url to have the taric file for a specific date" do
      expect(taric_file_name_generator.url).to eq("http://example.com/taric/TARIC320100101")
    end
  end
end
