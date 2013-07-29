require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::ChiefUpdate do
  it_behaves_like 'Base Update'

  let(:example_date)      { Date.new(2010,1,1) }

  describe '.download' do
    let(:blank_response)     { build :response, content: nil }
    let(:not_found_response) { build :response, :not_found }
    let(:success_response)   { build :response, :success, content: 'abc' }
    let(:update_name)        { "KBT009(10001).txt" }
    let(:url)                { "#{TariffSynchronizer.host}/taric/#{update_name}" }


    context 'has permission to write update file' do
      context 'single file for the day is found' do
        before do
          TariffSynchronizer.host = "http://example.com"
          prepare_synchronizer_folders
        end

        it 'downloads CHIEF file for specific date' do
          TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                         .with(url)
                                         .and_return(blank_response)

          TariffSynchronizer::ChiefUpdate.download(example_date)
        end

        it 'writes CHIEF file contents to file if they are not blank' do
          TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                         .with(url)
                                         .and_return(success_response)

          TariffSynchronizer::ChiefUpdate.download(example_date)

          File.exists?("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{success_response.file_name}").should be_true
          File.read("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{success_response.file_name}").should == 'abc'
        end

        it 'creates pending ChiefUpdate entry in the table' do
          TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                         .with(url)
                                         .and_return(success_response)
          TariffSynchronizer::ChiefUpdate.download(example_date)
          TariffSynchronizer::ChiefUpdate.count.should == 1
          TariffSynchronizer::ChiefUpdate.first.issue_date.should == example_date
        end
      end

      context 'when file for the day is not found' do
        let(:not_found_response) { build :response, :not_found }

        before {
          TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                         .and_return(not_found_response)
        }

        it 'does not write CHIEF file contents to file' do
          TariffSynchronizer::ChiefUpdate.download(example_date)

          File.exists?("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{update_name}").should be_false
        end

        it 'does not create not found entry if update is still for today' do
          TariffSynchronizer::ChiefUpdate.download(Date.today)

          TariffSynchronizer::ChiefUpdate.missing
                                         .with_issue_date(Date.today)
                                         .present?.should be_false
        end

        it 'creates not found entry if date has passed' do
          TariffSynchronizer::ChiefUpdate.download(Date.today)

          TariffSynchronizer::ChiefUpdate.missing
                                         .with_issue_date(Date.today)
                                         .present?.should be_false
        end
      end

      after  { purge_synchronizer_folders }
    end

    context 'has no permissions to write update file' do
      before do
        TariffSynchronizer.host = "http://example.com"
        prepare_synchronizer_folders

        File.chmod(0500, File.join(TariffSynchronizer.root_path, 'chief'))
      end

      it 'logs error about permissions' do
        TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                       .with(url)
                                       .and_return(success_response)

        TariffSynchronizer::ChiefUpdate.download(example_date)

        File.exists?("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{update_name}").should be_false
      end

      after  {
        File.chmod(0755, File.join(TariffSynchronizer.root_path, 'chief'))
        purge_synchronizer_folders
      }
    end
  end

  describe '.sync' do
    let(:not_found_response) { build :response, :not_found }

    context 'file not found for nth time in a row' do
      let!(:chief_update1) { create :chief_update, :missing, issue_date: Date.today.ago(2.days) }
      let!(:chief_update2) { create :chief_update, :missing, issue_date: Date.today.ago(3.days) }
      let!(:stub_logger)   { double.as_null_object }

      before {
        TariffSynchronizer::ChiefUpdate.stub(:download_content)
                                       .and_return(not_found_response)
      }

      it 'notifies about several missing updates in a row' do
        TariffSynchronizer::ChiefUpdate.should_receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::ChiefUpdate.sync
      end
    end
  end

  describe "#apply" do
    let(:example_date) { Forgery(:date).date }
    let(:state) { :pending }
    let!(:example_chief_update) { create :chief_update, example_date: example_date }

    before do
      prepare_synchronizer_folders
      create_chief_file state, example_date
    end

    it 'executes importer' do
      mock_importer = double
      mock_importer.should_receive(:import).and_return(true)
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::ChiefUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = double('importer').as_null_object
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      TariffSynchronizer::ChiefUpdate.first.apply
      TariffSynchronizer::ChiefUpdate.pending.count.should == 0
      TariffSynchronizer::ChiefUpdate.applied.count.should == 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = double
      mock_importer.should_receive(:import).and_raise(ChiefImporter::ImportException)
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      rescuing { TariffSynchronizer::ChiefUpdate.first.apply }
      TariffSynchronizer::ChiefUpdate.pending.count.should == 1
      TariffSynchronizer::ChiefUpdate.applied.count.should == 0
    end

    after  { purge_synchronizer_folders }
  end

  describe '.rebuild' do
    before {
      prepare_synchronizer_folders
      create_chief_file :pending, example_date
    }

    context 'entry for the day/update does not exist yet' do
      it 'creates db record from available file name' do
        TariffSynchronizer::BaseUpdate.count.should == 0

        TariffSynchronizer::ChiefUpdate.rebuild

        TariffSynchronizer::BaseUpdate.count.should == 1
        first_update = TariffSynchronizer::BaseUpdate.first
        first_update.issue_date.should == example_date
      end
    end

    context 'entry for the day/update exists already' do
      let!(:example_chief_update) { create :chief_update, example_date: example_date }

      it 'does not create db record if it is already available for the day/update type combo' do
        TariffSynchronizer::BaseUpdate.count.should == 1

        TariffSynchronizer::ChiefUpdate.rebuild

        TariffSynchronizer::BaseUpdate.count.should == 1
      end
    end

    after  { purge_synchronizer_folders }
  end
end
