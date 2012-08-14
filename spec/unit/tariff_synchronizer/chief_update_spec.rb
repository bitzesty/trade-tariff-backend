require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::ChiefUpdate do
  it_behaves_like 'Base Synchronizer'

  let(:example_date)      { Date.new(2010,1,1) }

  before do
    TariffSynchronizer.admin_email = "user@example.com"
  end

  describe '.download' do
    before do
      TariffSynchronizer.host = "http://example.com"
      prepare_synchronizer_folders
    end

    it 'downloads CHIEF file for specific date' do
      url = "#{TariffSynchronizer.host}/taric/KBT009(101).txt"

      TariffSynchronizer::FileService.expects(:get_content).with(url).returns(nil)

      TariffSynchronizer::ChiefUpdate.download(example_date)
    end

    it 'writes CHIEF file contents to file if they are not blank' do
      file_name = "KBT009(101).txt"
      url = "#{TariffSynchronizer.host}/taric/#{file_name}"

      TariffSynchronizer::FileService.expects(:get_content).with(url).returns('abc')

      TariffSynchronizer::ChiefUpdate.download(example_date)

      File.exists?("#{TariffSynchronizer.inbox_path}/#{example_date}_#{file_name}").should be_true
      File.read("#{TariffSynchronizer.inbox_path}/#{example_date}_#{file_name}").should == 'abc'
    end

    it 'does not write CHIEF file contents to file if they are blank' do
      file_name = "KBT009(101).txt"
      url = "#{TariffSynchronizer.host}/taric/#{file_name}"

      TariffSynchronizer::FileService.expects(:get_content).with(url).returns(nil)

      TariffSynchronizer::ChiefUpdate.download(example_date)

      File.exists?("#{TariffSynchronizer.inbox_path}/#{example_date}_#{file_name}").should be_false
    end

    after  { purge_synchronizer_folders }
  end

  describe ".query_for_last_file" do
    it 'returns query for CHIEF files' do
      TariffSynchronizer::ChiefUpdate.query_for_last_file.should == "#{TariffSynchronizer.root_path}/**/*.txt"
    end
  end

  describe "#apply" do
    before { prepare_synchronizer_folders }

    let(:example_chief_path) { create_chief_file :inbox, "2012-05-15" }

    it 'executes importer' do
      mock_importer = stub
      mock_importer.expects(:import).returns(true)
      TariffImporter.expects(:new).with(example_chief_path, ChiefImporter).returns(mock_importer)

      TariffSynchronizer::ChiefUpdate.new(example_chief_path).apply
    end

    it 'moves file to processed' do
      mock_importer = stub_everything
      TariffImporter.expects(:new).with(example_chief_path, ChiefImporter).returns(mock_importer)

      File.exists?(example_chief_path).should be_true
      chief_update = TariffSynchronizer::ChiefUpdate.new(example_chief_path)
      chief_update.apply
      File.exists?(example_chief_path).should be_false
      File.exists?("#{TariffSynchronizer.processed_path}/#{chief_update.file_name}").should be_true
    end

    it 'does not move file to processed if import fails' do
      mock_importer = stub
      mock_importer.expects(:import).raises(TariffImporter::TaricImportException)
      TariffImporter.expects(:new).with(example_chief_path, ChiefImporter).returns(mock_importer)

      File.exists?(example_chief_path).should be_true
      chief_update = TariffSynchronizer::ChiefUpdate.new(example_chief_path)
      rescuing { chief_update.apply }
      File.exists?(example_chief_path).should be_true
      File.exists?("#{TariffSynchronizer.processed_path}/#{chief_update.file_name}").should be_false
    end

    after  { purge_synchronizer_folders }
  end
end
