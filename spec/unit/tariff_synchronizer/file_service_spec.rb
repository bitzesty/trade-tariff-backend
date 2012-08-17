require 'spec_helper'
require 'date'
require 'tariff_synchronizer'
require 'tariff_synchronizer/file_service'

describe TariffSynchronizer::FileService do
  describe ".get_date" do
    let(:example_taric_name) { "2012-08-06_TGB12152.xml" }
    let(:example_chief_name) { "2012-05-15_KBT009(12136).txt" }

    it 'returns parsed date from Taric file name prefix' do
      TariffSynchronizer::FileService.get_date(example_taric_name).should_not be_blank
      TariffSynchronizer::FileService.get_date(example_taric_name).should be_kind_of Date
      TariffSynchronizer::FileService.get_date(example_taric_name).should == Date.new(2012,8,6)
    end

    it 'returns parsed date from CHIEF file name prefix' do
      TariffSynchronizer::FileService.get_date(example_chief_name).should_not be_blank
      TariffSynchronizer::FileService.get_date(example_chief_name).should be_kind_of Date
      TariffSynchronizer::FileService.get_date(example_chief_name).should == Date.new(2012,5,15)
    end

    it 'returns nil if passed a blank value' do
      TariffSynchronizer::FileService.get_date(nil).should be_blank
    end
  end

  describe ".write_file" do
    let(:example_content) { Forgery(:basic).text }
    let(:example_name)    { Forgery(:basic).text }
    let(:example_path)    { "tmp/#{example_name}.sample" }

    before {
      TariffSynchronizer::FileService.write_file(example_path, example_content)
    }

    it 'writes provided content to provided path' do
      File.exists?(example_path).should be_true
      File.read(example_path).should == example_content
    end

    after { File.delete(example_path) }
  end

  describe ".get_content", :webmock do
    let(:example_url) { "http://example.com/data" }

    it 'downloads content from remote url' do
      VCR.use_cassette('example_get_content') do
        TariffSynchronizer::FileService.get_content(example_url).should == "Hello world"
      end
    end
  end
end
