require "rails_helper"
require "tariff_synchronizer/tariff_downloader"

describe TariffSynchronizer::CdsUpdateDownloader do
  let(:example_date) { Date.new(2020,10,10) }
  let(:downloader) { described_class.new(example_date) }

  describe "#perform" do
    it "checks if already downloaded" do
      allow(downloader).to receive(:check_date_already_downloaded?) { true }
      expect(downloader).to receive(:check_date_already_downloaded?)
      downloader.perform
    end

    context "when downloaded" do
      before do
        FactoryBot.create(:cds_update, issue_date: example_date)
      end

      it "returns nil" do
        expect(downloader.perform).to be_nil
      end

      it "does not log request to cds daily updates" do
        expect(downloader).not_to receive(:log_request_to_cds_daily_updates)
        downloader.perform
      end
    end

    context "when not downloaded" do
      let(:body) { 
        [{
           "filename"=>"tariff_dailyExtract_v1_20201010T235959.gzip",
           "downloadURL"=>"https://sdes.hmrc.gov.uk/api-download/156ec583-9245-484a-9f91-3919493a047d",
           "fileSize"=>12345 
         }]
      }
      
      before do
        allow(downloader).to receive(:response) { double("Response", body: body.to_json) }
        allow_any_instance_of(TariffSynchronizer::TariffDownloader).to receive(:perform)
      end
      
      it "logs request to cds daily updates" do
        expect(downloader).to receive(:log_request_to_cds_daily_updates)
        downloader.perform
      end
      
      context "when response contains example_date" do
        it "calls TariffDownloader" do
          expect(TariffSynchronizer::TariffDownloader).to receive(:new).with(
            body[0]["filename"], body[0]["downloadURL"], example_date, TariffSynchronizer::CdsUpdate
          ).and_call_original
          downloader.perform
        end

        it 'does not create missing update record' do
          expect{ downloader.perform }.not_to change(TariffSynchronizer::BaseUpdate.missing, :count)
        end
      end
      
      context "when response does not contain example_date" do
        before do
          body[0]["filename"] = "tariff_dailyExtract_v1_20201015T235959.gzip"
        end

        it "does not call TariffDownloader" do
          expect(TariffSynchronizer::TariffDownloader).not_to receive(:new)
          downloader.perform
        end
        
        it "creates missing update record" do
          expect(downloader).to receive(:create_record_for_not_found_response).and_call_original
          expect{ downloader.perform }.to change(TariffSynchronizer::BaseUpdate.missing, :count).by(1)

          update = TariffSynchronizer::CdsUpdate.last
          expect(update.filename).to eq("2020-10-10_cds")
          expect(update.filesize).to be_nil
          expect(update.issue_date).to eq(example_date)
          expect(update.state).to eq(TariffSynchronizer::BaseUpdate::MISSING_STATE)
        end
        
        it "returns nil" do
          expect(downloader.perform).to be_nil
        end
      end
    end
  end
end
