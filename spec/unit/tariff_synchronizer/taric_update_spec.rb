require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::TaricUpdate do
  it_behaves_like 'Base Update'

  let(:example_date)      { Forgery(:date).date }

  describe '.download' do
    let(:taric_update_name)  { "TGB#{example_date.strftime("%y")}#{example_date.yday}.xml" }
    let(:taric_query_url)    { "#{TariffSynchronizer.host}/taric/TARIC3#{example_date.strftime("%Y%m%d")}" }
    let(:blank_response)     { build :response, content: nil }
    let(:not_found_response) { build :response, :not_found }
    let(:success_response)   { build :response, :success, content: 'abc' }
    let(:failed_response)    { build :response, :failed }
    let(:update_url)         { "#{TariffSynchronizer.host}/taric/#{taric_update_name}" }


    before do
      TariffSynchronizer.host = "http://example.com"
      prepare_synchronizer_folders
    end

    context "when single file for the day is found" do
      let(:query_response)     { build :response, :success, url: taric_query_url,
                                                         content: taric_update_name }
      before {
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_query_url)
                                       .and_return(query_response)
      }

      it 'downloads Taric file for specific date' do
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(update_url)
                                       .and_return(blank_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
      end

      it 'writes Taric file contents to file if they are not blank' do
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(update_url)
                                       .and_return(success_response)

        TariffSynchronizer::TaricUpdate.download(example_date)

        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response.file_name}").should be_true
        File.read("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response.file_name}").should == 'abc'
      end

      it 'does not write Taric file contents to file if they are blank' do
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(update_url)
                                       .and_return(blank_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_false
      end
    end

    context "when multiple files for the day are found" do
      let(:taric_update_names) { ["1.xml", "2.xml"] }
      let(:query_response)     { build :response, :success, url: taric_query_url,
                                                            content: taric_update_names.join("\n") }
      let(:taric_update_url)    { "#{TariffSynchronizer.host}/taric/%{name}" }
      let(:success_response_1)  { build :response, :success, content: 'abc' }
      let(:success_response_2)  { build :response, :success, content: 'def' }

      before {
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_query_url)
                                       .and_return(query_response)
      }

      after  { purge_synchronizer_folders }

      it 'downloads Taric file for specific date' do
        taric_update_names.each do |name|
          TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                         .with(taric_update_url % { name: name })
                                         .and_return(blank_response)
        end

        TariffSynchronizer::TaricUpdate.download(example_date)
      end

      it 'writes Taric file contents to file if they are not blank' do
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.first })
                                       .and_return(success_response_1)
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.last })
                                       .and_return(success_response_2)

        TariffSynchronizer::TaricUpdate.download(example_date)

        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_1.file_name}").should be_true
        File.read("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_1.file_name}").should == 'abc'
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_2.file_name}").should be_true
        File.read("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_2.file_name}").should == 'def'
      end

      it 'does not write Taric file contents to file if they are blank' do
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.first })
                                       .and_return(blank_response)
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.last })
                                       .and_return(blank_response)

        TariffSynchronizer::TaricUpdate.download(example_date)

        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_1.file_name}").should be_false
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_2.file_name}").should be_false
      end
    end

    context 'when file for the day is not found' do
      before {
        TariffSynchronizer::TaricUpdate.should_receive(:download_content)
                                       .and_return(not_found_response)
      }

      it 'does not write Taric file contents to file' do
        TariffSynchronizer::TaricUpdate.download(example_date)

        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_false
      end

      it 'does not create not found entry if update is still for today' do
        TariffSynchronizer::TaricUpdate.download(Date.today)

        TariffSynchronizer::TaricUpdate.missing
                                       .with_issue_date(Date.today)
                                       .present?.should be_false
      end

      it 'creates not found entry if date has passed' do
        TariffSynchronizer::TaricUpdate.download(Date.yesterday)

        TariffSynchronizer::TaricUpdate.missing
                                       .with_issue_date(Date.yesterday)
                                       .present?.should be_true
      end
    end

    context 'retry count exceeded (failed update)' do
      let(:update_url)   { "#{TariffSynchronizer.host}/taric/abc" }
      let(:example_date) { Date.yesterday }

      before {
        TariffSynchronizer.retry_count = 1

        TariffSynchronizer::TaricUpdate.should_receive(:send_request)
                                       .with(taric_query_url)
                                       .and_return(success_response)

        TariffSynchronizer::TaricUpdate.should_receive(:send_request)
                                       .with(update_url)
                                       .twice
                                       .and_return(failed_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
      }

      it 'does not write file to file system' do
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_false
      end

      it 'creates failed update entry' do
        TariffSynchronizer::TaricUpdate.failed
                                       .with_issue_date(example_date)
                                       .present?.should be_true
      end
    end

    context 'downloaded file is blank' do
      let(:update_url) { "#{TariffSynchronizer.host}/taric/abc" }
      let(:blank_success_response)   { build :response, :success, content: '' }

      before {
        TariffSynchronizer::TaricUpdate.should_receive(:send_request)
                                       .with(taric_query_url)
                                       .and_return(success_response)

        TariffSynchronizer::TaricUpdate.should_receive(:send_request)
                                       .with(update_url)
                                       .and_return(blank_success_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
      }

      it 'does not write file to file system' do
        File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}").should be_false
      end

      it 'creates failed update entry' do
        TariffSynchronizer::TaricUpdate.failed
                                       .with_issue_date(example_date)
                                       .present?.should be_true
      end
    end
  end

  describe '.sync' do
    let(:not_found_response) { build :response, :not_found }

    context 'file not found for nth time in a row' do
      let!(:taric_update1) { create :taric_update, :missing, issue_date: Date.today.ago(2.days) }
      let!(:taric_update2) { create :taric_update, :missing, issue_date: Date.today.ago(3.days) }

      before {
        TariffSynchronizer::TaricUpdate.stub(:download_content)
                                       .and_return(not_found_response)
      }

      it 'notifies about several missing updates in a row' do
        TariffSynchronizer::TaricUpdate.should_receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::TaricUpdate.sync
      end
    end
  end

  describe "#apply" do
    let(:state) { :pending }
    let!(:example_taric_update) { create :taric_update, example_date: example_date }

    before {
      prepare_synchronizer_folders
      create_taric_file :pending, example_date
    }

    it 'executes Taric importer' do
      mock_importer = double('importer').as_null_object
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::TaricUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = double('importer').as_null_object
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      TariffSynchronizer::TaricUpdate.first.apply
      TariffSynchronizer::TaricUpdate.pending.count.should == 0
      TariffSynchronizer::TaricUpdate.applied.count.should == 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = double
      mock_importer.should_receive(:import).and_raise(TaricImporter::ImportException)
      TariffImporter.should_receive(:new).and_return(mock_importer)

      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      rescuing { TariffSynchronizer::TaricUpdate.first.apply }
      TariffSynchronizer::TaricUpdate.pending.count.should == 1
      TariffSynchronizer::TaricUpdate.applied.count.should == 0
    end

    after  { purge_synchronizer_folders }
  end

  describe '.rebuild' do
    before {
      prepare_synchronizer_folders
      create_taric_file :pending, example_date
    }

    after { purge_synchronizer_folders }

    context 'entry for the day/update does not exist yet' do
      it 'creates db record from available file name' do
        TariffSynchronizer::BaseUpdate.count.should == 0

        TariffSynchronizer::TaricUpdate.rebuild

        TariffSynchronizer::BaseUpdate.count.should == 1
        first_update = TariffSynchronizer::BaseUpdate.first
        first_update.issue_date.should == example_date
      end
    end

    context 'entry for the day/update exists already' do
      let!(:example_taric_update) { create :taric_update, example_date: example_date }

      it 'does not create db record if it is already available for the day/update type combo' do
        TariffSynchronizer::BaseUpdate.count.should == 1

        TariffSynchronizer::TaricUpdate.rebuild

        TariffSynchronizer::BaseUpdate.count.should == 1
      end
    end
  end
end
