require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::ChiefUpdate do
  it_behaves_like 'Base Update'

  let(:example_date)      { Date.new(2010,1,1) }

  before do
    # we assume csv contents are ok unless otherwise specified
    allow(TariffSynchronizer::ChiefUpdate).to receive(:validate_file!)
                                          .and_return(true)
  end

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

        context 'file for the day not downloaded yet' do
          it 'downloads CHIEF file for specific date' do
            expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                           .with(url)
                                           .and_return(blank_response)

            TariffSynchronizer::ChiefUpdate.download(example_date)
          end

          it 'writes CHIEF file contents to file if they are not blank' do
            expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                           .with(url)
                                           .and_return(success_response)

            TariffSynchronizer::ChiefUpdate.download(example_date)

            expect(
              File.exists?("#{TariffSynchronizer.root_path}/chief/#{TariffSynchronizer::ChiefUpdate.file_name_for(example_date)}")
            ).to be_truthy
            expect(
              File.read("#{TariffSynchronizer.root_path}/chief/#{TariffSynchronizer::ChiefUpdate.file_name_for(example_date)}")
            ).to eq 'abc'
          end

          it 'creates pending ChiefUpdate entry in the table' do
            expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                           .with(url)
                                           .and_return(success_response)
            TariffSynchronizer::ChiefUpdate.download(example_date)
            expect(TariffSynchronizer::ChiefUpdate.count).to eq 1
            expect(TariffSynchronizer::ChiefUpdate.first.issue_date).to eq example_date
            expect(TariffSynchronizer::ChiefUpdate.first.filesize).to eq success_response.content.size
          end
        end

        context 'file for the day already downloaded' do
          let!(:present_chief_update) {
            create :chief_update,
              :applied,
              issue_date: example_date,
              filename: TariffSynchronizer::ChiefUpdate.file_name_for(example_date)
          }

          before {
            expect(TariffSynchronizer::ChiefUpdate).to receive(
              :download_content
            ).with(url).and_return(success_response)

            TariffSynchronizer::ChiefUpdate.download(example_date)

            expect(
              File.exists?("#{TariffSynchronizer.root_path}/chief/#{TariffSynchronizer::ChiefUpdate.file_name_for(example_date)}")
            ).to be_truthy
          }

          it 'does not download CHIEF file for date when it exists' do
            expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                           .never

            TariffSynchronizer::ChiefUpdate.download(example_date)
          end

          it 'does not create additional ChiefUpdate entries' do
            expect {
              TariffSynchronizer::ChiefUpdate.download(example_date)
            }.to_not change { TariffSynchronizer::ChiefUpdate.count }
          end
        end

        context "invalid csv contents" do
          let(:success_response) {
            build :response, :success,
                             content: '"header1","header2'
          }
          let(:update_entry) {
            TariffSynchronizer::ChiefUpdate.last
          }

          before {
            expect(
              TariffSynchronizer::ChiefUpdate
            ).to receive(:download_content)
             .with(url)
             .and_return(success_response)

            # unstub
            allow(TariffSynchronizer::ChiefUpdate).to receive(:validate_file!)
                                                  .and_call_original
          }

          it {
            TariffSynchronizer::ChiefUpdate.download(example_date)

            expect(update_entry.exception_class).to include("CSV::MalformedCSVError")
          }
        end
      end

      context 'when file for the day is not found' do
        let(:not_found_response) { build :response, :not_found }

        before {
          expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                         .and_return(not_found_response)
        }

        it 'does not write CHIEF file contents to file' do
          TariffSynchronizer::ChiefUpdate.download(example_date)

          expect(
            File.exists?("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{update_name}")
          ).to be_falsy
        end

        it 'does not create not found entry if update is still for today' do
          TariffSynchronizer::ChiefUpdate.download(Date.today)

          expect(
            TariffSynchronizer::ChiefUpdate.missing
                                           .with_issue_date(Date.today)
                                           .present?
          ).to be_falsy
        end

        it 'creates not found entry if date has passed' do
          TariffSynchronizer::ChiefUpdate.download(Date.today)

          expect(
            TariffSynchronizer::ChiefUpdate.missing
                                           .with_issue_date(Date.today)
                                           .present?
          ).to be_falsy
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
        expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                               .with(url)
                                               .and_return(success_response)

        TariffSynchronizer::ChiefUpdate.download(example_date)

        expect(
          File.exists?("#{TariffSynchronizer.root_path}/chief/#{example_date}_#{update_name}")
        ).to be_falsy
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
        allow(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                              .and_return(not_found_response)
      }

      it 'notifies about several missing updates in a row' do
        expect(TariffSynchronizer::ChiefUpdate).to receive(:notify_about_missing_updates).and_return(true)
        TariffSynchronizer::ChiefUpdate.sync
      end
    end
  end

  describe "#apply", truncation: true do
    let(:example_date) { Forgery(:date).date }
    let(:state) { :pending }
    let!(:example_chief_update) { create :chief_update, example_date: example_date }

    before do
      prepare_synchronizer_folders
      create_chief_file state, example_date
    end

    it 'sets applied_at' do
      TariffSynchronizer::ChiefUpdate.first.apply
      expect(example_chief_update.reload.applied_at).to_not be_nil
    end

    it 'executes importer' do
      mock_importer = double
      expect(mock_importer).to receive(:import).and_return(true)
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      TariffSynchronizer::ChiefUpdate.first.apply
    end

    it 'updates file entry state to processed' do
      mock_importer = double('importer').as_null_object
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 1
      TariffSynchronizer::ChiefUpdate.first.apply
      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.applied.count).to eq 1
    end

    it 'does not move file to processed if import fails' do
      mock_importer = double
      expect(mock_importer).to receive(:import).and_raise(ChiefImporter::ImportException)
      expect(TariffImporter).to receive(:new).and_return(mock_importer)

      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 1
      rescuing { TariffSynchronizer::ChiefUpdate.first.apply }
      expect(TariffSynchronizer::ChiefUpdate.pending.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.applied.count).to eq 0
      expect(TariffSynchronizer::ChiefUpdate.failed.count).to eq 1
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
        expect(TariffSynchronizer::BaseUpdate.count).to eq 0

        TariffSynchronizer::ChiefUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
        first_update = TariffSynchronizer::BaseUpdate.first
        expect(first_update.issue_date).to eq example_date
      end
    end

    context 'entry for the day/update exists already' do
      let!(:example_chief_update) { create :chief_update, example_date: example_date }

      it 'does not create db record if it is already available for the day/update type combo' do
        expect(TariffSynchronizer::BaseUpdate.count).to eq 1

        TariffSynchronizer::ChiefUpdate.rebuild

        expect(TariffSynchronizer::BaseUpdate.count).to eq 1
      end
    end

    after  { purge_synchronizer_folders }
  end
end
