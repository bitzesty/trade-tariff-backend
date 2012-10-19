require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::ChiefUpdate do
  it_behaves_like 'Base Update'

  let(:example_date)      { Date.new(2010,1,1) }

  before do
    TariffSynchronizer.admin_email = "user@example.com"
  end

  describe '.download' do
    before do
      TariffSynchronizer.host = "http://example.com"
    end

    it 'downloads CHIEF file for specific date' do
      url = "#{TariffSynchronizer.host}/taric/KBT009(101).txt"

      TariffSynchronizer::DownloadService.expects(:get_content).with(url).returns(nil)

      TariffSynchronizer::ChiefUpdate.download(example_date)
    end

    it 'writes CHIEF file contents to db if they are not blank' do
      file_name = "KBT009(101).txt"
      url = "#{TariffSynchronizer.host}/taric/#{file_name}"

      TariffSynchronizer::DownloadService.expects(:get_content).with(url).returns('abc')

      TariffSynchronizer::ChiefUpdate.download(example_date)
      TariffSynchronizer::ChiefUpdate.first.file.should == 'abc'
    end

    it 'creates pending ChiefUpdate entry in the table' do
      url = "#{TariffSynchronizer.host}/taric/KBT009(101).txt"

      TariffSynchronizer::DownloadService.expects(:get_content).with(url).returns('abc')
      TariffSynchronizer::ChiefUpdate.download(example_date)
      TariffSynchronizer::ChiefUpdate.count.should == 1
      TariffSynchronizer::ChiefUpdate.first.issue_date.should == example_date
    end
  end

  describe "#apply" do
    let(:example_date) { Forgery(:date).date }
    let(:state) { :pending }
    let!(:example_chief_update) { create :chief_update, example_date: example_date }

    it 'executes importer' do
      mock_importer = stub
      mock_importer.expects(:import).returns(true)
      TariffImporter.expects(:new).returns(mock_importer)

      TariffSynchronizer::ChiefUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = stub_everything
      TariffImporter.expects(:new).returns(mock_importer)

      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      TariffSynchronizer::ChiefUpdate.first.apply
      TariffSynchronizer::ChiefUpdate.pending.count.should == 0
      TariffSynchronizer::ChiefUpdate.applied.count.should == 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = stub
      mock_importer.expects(:import).raises(ChiefImporter::ImportException)
      TariffImporter.expects(:new).returns(mock_importer)

      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      rescuing { TariffSynchronizer::ChiefUpdate.first.apply }
      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      TariffSynchronizer::ChiefUpdate.applied.count.should == 0
    end
  end
end
