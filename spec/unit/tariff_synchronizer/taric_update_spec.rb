require 'spec_helper'
require 'tariff_synchronizer'
require 'mocha/standalone'

describe TariffSynchronizer::TaricUpdate do
  it_behaves_like 'Base Synchronizer'

  let(:example_date)      { Date.new(2010,1,1) }

  before do
    TariffSynchronizer.admin_email = "user@example.com"
  end

  describe '.download' do
    let(:taric_update_name) { "TGB12345.xml" }

    before do
      TariffSynchronizer.host = "http://example.com"
      prepare_synchronizer_folders
    end

    context "when file for the day is found" do
      before do
        taric_query_url = "#{TariffSynchronizer.host}/taric/TARIC3#{example_date.strftime("%Y%m%d")}"
        TariffSynchronizer::FileService.expects(:get_content).with(taric_query_url).returns(taric_update_name)
      end

      it 'downloads Taric file for specific date' do
        update_url = "#{TariffSynchronizer.host}/taric/#{taric_update_name}"

        TariffSynchronizer::FileService.expects(:get_content).with(update_url).returns(nil)

        TariffSynchronizer::TaricUpdate.download(example_date)
      end

      it 'writes Taric file contents to file if they are not blank' do
        update_url = "#{TariffSynchronizer.host}/taric/#{taric_update_name}"

        TariffSynchronizer::FileService.expects(:get_content).with(update_url).returns('abc')

        TariffSynchronizer::TaricUpdate.download(example_date)
        File.exists?("#{TariffSynchronizer.inbox_path}/#{example_date}_#{taric_update_name}").should be_true
        File.read("#{TariffSynchronizer.inbox_path}/#{example_date}_#{taric_update_name}").should == 'abc'
      end

      it 'does not write Taric file contents to file if they are blank' do
        update_url = "#{TariffSynchronizer.host}/taric/#{taric_update_name}"

        TariffSynchronizer::FileService.expects(:get_content).with(update_url).returns(nil)

        TariffSynchronizer::TaricUpdate.download(example_date)
        File.exists?("#{TariffSynchronizer.inbox_path}/#{example_date}_#{taric_update_name}").should be_false
      end
    end

    context "when file for the day is not found" do
      it 'does not write Taric file contents to file if they are blank' do
        taric_query_url = "#{TariffSynchronizer.host}/taric/TARIC3#{example_date.strftime("%Y%m%d")}"
        TariffSynchronizer::FileService.expects(:get_content).with(taric_query_url).returns(nil)
        TariffSynchronizer.logger.expects(:error).returns(true)

        TariffSynchronizer::TaricUpdate.download(example_date)
      end
    end

    after  { purge_synchronizer_folders }
  end

  describe ".query_for_last_file" do
    it 'returns query for Taric files' do
      TariffSynchronizer::TaricUpdate.query_for_last_file.should == "#{TariffSynchronizer.root_path}/**/*.xml"
    end
  end

  describe "#apply" do
    before { prepare_synchronizer_folders }

    let(:example_taric_path) { create_taric_file :inbox, "2012-05-15" }

    it 'executes Taric importer' do
      mock_importer = stub
      mock_importer.expects(:import).returns(true)
      TariffImporter.expects(:new).with(example_taric_path, TaricImporter).returns(mock_importer)

      TariffSynchronizer::TaricUpdate.new(example_taric_path).apply
    end

    it 'moves file to processed' do
      mock_importer = stub_everything
      TariffImporter.expects(:new).with(example_taric_path, TaricImporter).returns(mock_importer)

      File.exists?(example_taric_path).should be_true
      taric_update = TariffSynchronizer::TaricUpdate.new(example_taric_path)
      taric_update.apply
      File.exists?(example_taric_path).should be_false
      File.exists?("#{TariffSynchronizer.processed_path}/#{taric_update.file_name}").should be_true
    end

    it 'does not move file to processed if import fails' do
      mock_importer = stub
      mock_importer.expects(:import).raises(TariffImporter::ChiefImportException)
      TariffImporter.expects(:new).with(example_taric_path, TaricImporter).returns(mock_importer)

      File.exists?(example_taric_path).should be_true
      taric_update = TariffSynchronizer::TaricUpdate.new(example_taric_path)
      rescuing { taric_update.apply }
      File.exists?(example_taric_path).should be_true
      File.exists?("#{TariffSynchronizer.processed_path}/#{taric_update.file_name}").should be_false
    end

    after  { purge_synchronizer_folders }
  end
end
