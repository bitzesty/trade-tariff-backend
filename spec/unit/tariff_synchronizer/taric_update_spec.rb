require 'spec_helper'
require 'tariff_synchronizer'
require 'mocha/standalone'

describe TariffSynchronizer::TaricUpdate do
  it_behaves_like 'Base Update'

  let(:example_date)      { Forgery(:date).date }

  before do
    TariffSynchronizer.admin_email = "user@example.com"
  end

  describe '.download' do
    let(:taric_update_name) { "TGB#{example_date.strftime("%y")}#{example_date.yday}.xml" }

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
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_true
        File.read("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should == 'abc'
      end

      it 'does not write Taric file contents to file if they are blank' do
        update_url = "#{TariffSynchronizer.host}/taric/#{taric_update_name}"

        TariffSynchronizer::FileService.expects(:get_content).with(update_url).returns(nil)

        TariffSynchronizer::TaricUpdate.download(example_date)
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_false
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

  describe "#apply" do
    let(:state) { :pending }
    let!(:example_taric_update) { create :taric_update, example_date: example_date }

    before {
      prepare_synchronizer_folders
      create_taric_file :pending, example_date
    }

    it 'executes Taric importer' do
      mock_importer = stub_everything
      TariffImporter.expects(:new).with(example_taric_update.file_path, TaricImporter).returns(mock_importer)

      TariffSynchronizer::TaricUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = stub_everything
      TariffImporter.expects(:new).with(example_taric_update.file_path, TaricImporter).returns(mock_importer)

      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      TariffSynchronizer::TaricUpdate.first.apply
      TariffSynchronizer::TaricUpdate.pending.count.should == 0
      TariffSynchronizer::TaricUpdate.applied.count.should == 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = stub
      mock_importer.expects(:import).raises(TaricImporter::ImportException)
      TariffImporter.expects(:new).with(example_taric_update.file_path, TaricImporter).returns(mock_importer)

      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      rescuing { TariffSynchronizer::TaricUpdate.first.apply }
      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      TariffSynchronizer::TaricUpdate.applied.count.should == 0
    end

    after  { purge_synchronizer_folders }
  end
end
