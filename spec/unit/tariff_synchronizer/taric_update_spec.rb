require 'rails_helper'
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

      # we assume contents are ok unless otherwise specified
      allow(TariffSynchronizer::TaricUpdate).to receive(:validate_file!)
                                            .and_return(true)
    end

    after  { purge_synchronizer_folders }

    context "when single file for the day is found" do
      let(:query_response)     { build :response, :success, url: taric_query_url,
                                                         content: taric_update_name }

      before {
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_query_url)
                                       .and_return(query_response)
      }

      context 'update not downloaded yet' do

        it 'downloads Taric file for specific date' do
          expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                         .with(update_url)
                                         .and_return(blank_response)

          TariffSynchronizer::TaricUpdate.download(example_date)
        end

        it 'writes Taric file contents to file if they are not blank' do
          expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                         .with(update_url)
                                         .and_return(success_response)

          TariffSynchronizer::TaricUpdate.download(example_date)

          expect(
            File.exists?("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_name)}")
          ).to be_truthy
          expect(
            File.read("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_name)}")
          ).to eq 'abc'
        end

        it 'does not write Taric file contents to file if they are blank' do
          expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                         .with(update_url)
                                         .and_return(blank_response)

          TariffSynchronizer::TaricUpdate.download(example_date)
          expect(
            File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}")
          ).to be_falsy
        end
      end

      describe "content validation" do
        before {
          expect(
            TariffSynchronizer::TaricUpdate
          ).to receive(:download_content)
           .with(update_url)
           .and_return(success_response)

          allow(TariffSynchronizer::TaricUpdate).to receive(:validate_file!) do
            original = Nokogiri::XML::SyntaxError.new
            raise TariffSynchronizer::BaseUpdate::InvalidContents.new(
              original.message,
              original
            )
          end
        }

        let(:update_entry) {
          TariffSynchronizer::TaricUpdate.last
        }

        it "marks an update as failed if the file contents cannot be parsed" do
          TariffSynchronizer::TaricUpdate.download(example_date)

          expect(update_entry.exception_class).to include("Nokogiri::XML::SyntaxError")
        end
      end
    end


    context 'update already downloaded' do
      let(:query_response)  {
        build :response, :success, url: taric_query_url, content: taric_update_name
      }

      let!(:present_taric_update) {
        create :taric_update,
          :applied,
          issue_date: example_date,
          filename: TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_name)
      }

      before {
        expect(TariffSynchronizer::TaricUpdate).to receive(
          :download_content).with(taric_query_url).and_return(query_response)

        File.new("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_name)}", "w").write('abc')
      }

      it 'does not download TARIC file for date' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(update_url)
                                       .never

        TariffSynchronizer::TaricUpdate.download(example_date)
      end

      it 'does not create additional TaricUpdate entries' do
        TariffSynchronizer::TaricUpdate.download(example_date)
        expect(
          TariffSynchronizer::TaricUpdate.where(issue_date: example_date).count
        ).to eq 1
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
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_query_url)
                                       .and_return(query_response)
      }

      after  { purge_synchronizer_folders }

      it 'downloads Taric file for specific date' do
        taric_update_names.each do |name|
          expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                         .with(taric_update_url % { name: name })
                                         .and_return(blank_response)
        end

        TariffSynchronizer::TaricUpdate.download(example_date)
      end

      it 'writes Taric file contents to file if they are not blank' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.first })
                                       .and_return(success_response_1)
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.last })
                                       .and_return(success_response_2)

        TariffSynchronizer::TaricUpdate.download(example_date)

        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_names.first)}")
        ).to be_truthy
        expect(
          File.read("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_names.first)}")
        ).to eq 'abc'
        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_names.last)}")
        ).to be_truthy
        expect(
          File.read("#{TariffSynchronizer.root_path}/taric/#{TariffSynchronizer::TaricUpdate.file_name_for(example_date, taric_update_names.last)}")
        ).to eq 'def'
      end

      it 'does not write Taric file contents to file if they are blank' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.first })
                                       .and_return(blank_response)
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .with(taric_update_url % { name: taric_update_names.last })
                                       .and_return(blank_response)

        TariffSynchronizer::TaricUpdate.download(example_date)

        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_1.file_name}")
        ).to be_falsy
        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{success_response_2.file_name}")
        ).to be_falsy
      end
    end

    context 'when file for the day is not found' do
      before {
        expect(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                       .and_return(not_found_response)
      }

      it 'does not write Taric file contents to file' do
        TariffSynchronizer::TaricUpdate.download(example_date)

        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}")
        ).to be_falsy
      end

      it 'does not create not found entry if update is still for today' do
        TariffSynchronizer::TaricUpdate.download(Date.today)

        expect(
          TariffSynchronizer::TaricUpdate.missing
                                       .with_issue_date(Date.today)
                                       .present?
        ).to be_falsy
      end

      it 'creates not found entry if date has passed' do
        TariffSynchronizer::TaricUpdate.download(Date.yesterday)

        expect(
          TariffSynchronizer::TaricUpdate.missing
                                       .with_issue_date(Date.yesterday)
                                       .present?
        ).to be_truthy
      end
    end

    context 'retry count exceeded (failed update)' do
      let(:update_url)   { "#{TariffSynchronizer.host}/taric/abc" }
      let(:example_date) { Date.yesterday }

      before {
        TariffSynchronizer.retry_count = 1

        expect(TariffSynchronizer::TaricUpdate).to receive(:send_request)
                                       .with(taric_query_url)
                                       .and_return(success_response)

        expect(TariffSynchronizer::TaricUpdate).to receive(:send_request)
                                       .with(update_url)
                                       .twice
                                       .and_return(failed_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
      }

      it 'does not write file to file system' do
        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}")
        ).to be_falsy
      end

      it 'creates failed update entry' do
        expect(
          TariffSynchronizer::TaricUpdate.failed
                                       .with_issue_date(example_date)
                                       .present?
        ).to be_truthy
      end
    end

    context 'downloaded file is blank' do
      let(:update_url) { "#{TariffSynchronizer.host}/taric/abc" }
      let(:blank_success_response)   { build :response, :success, content: '' }

      before {
        expect(TariffSynchronizer::TaricUpdate).to receive(:send_request)
                                       .with(taric_query_url)
                                       .and_return(success_response)

        expect(TariffSynchronizer::TaricUpdate).to receive(:send_request)
                                       .with(update_url)
                                       .and_return(blank_success_response)

        TariffSynchronizer::TaricUpdate.download(example_date)
      }

      it 'does not write file to file system' do
        expect(
          File.exists?("#{TariffSynchronizer.root_path}/taric/#{example_date}_#{taric_update_name}")
        ).to be_falsy
      end

      it 'creates failed update entry' do
        expect(
          TariffSynchronizer::TaricUpdate.failed
                                       .with_issue_date(example_date)
                                       .present?
        ).to be_truthy
      end
    end
  end

  describe '.sync' do
    let(:not_found_response) { build :response, :not_found }

    context 'file not found for nth time in a row' do
      let!(:taric_update1) { create :taric_update, :missing, issue_date: Date.today.ago(2.days) }
      let!(:taric_update2) { create :taric_update, :missing, issue_date: Date.today.ago(3.days) }

      before {
        allow(TariffSynchronizer::TaricUpdate).to receive(:download_content)
                                              .and_return(not_found_response)
      }

      it 'notifies about several missing updates in a row' do
        expect(TariffSynchronizer::TaricUpdate).to receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::TaricUpdate.sync
      end
    end
  end

  describe "#apply", truncation: true do
    let(:state) { :pending }
    let!(:example_taric_update) { create :taric_update, example_date: example_date }

    before {
      prepare_synchronizer_folders
      create_taric_file :pending, example_date
    }

    it 'executes Taric importer' do
      mock_importer = double('importer').as_null_object
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      TariffSynchronizer::TaricUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = double('importer').as_null_object
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::TaricUpdate.pending.count).to eq 1
      TariffSynchronizer::TaricUpdate.first.apply
      expect(TariffSynchronizer::TaricUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::TaricUpdate.applied.count).to eq 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = double
      expect(mock_importer).to receive(:import).and_raise(TaricImporter::ImportException)
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::TaricUpdate.pending.count).to eq 1

      expect { TariffSynchronizer::TaricUpdate.first.apply }.to raise_error Sequel::Rollback

      expect(TariffSynchronizer::TaricUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::TaricUpdate.failed.count).to eq 1
      expect(TariffSynchronizer::TaricUpdate.applied.count).to eq 0
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
        expect(TariffSynchronizer::BaseUpdate.count).to eq 0

        TariffSynchronizer::TaricUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
        first_update = TariffSynchronizer::BaseUpdate.first
        expect(first_update.issue_date).to eq example_date
      end
    end

    context 'entry for the day/update exists already' do
      let!(:example_taric_update) { create :taric_update, example_date: example_date }

      it 'does not create db record if it is already available for the day/update type combo' do
        expect(TariffSynchronizer::BaseUpdate.count).to eq 1

        TariffSynchronizer::TaricUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
      end
    end
  end
end
