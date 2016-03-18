require "rails_helper"
require "sidekiq/middleware/server/retry_jobs"

describe DownloadUpdatesWorker do
  let(:string_date) { "2010-01-01" }
  let(:date) { Date.parse(string_date) }
  let(:root_path) { TariffSynchronizer.root_path }

  describe "#perform" do

    context "Downloading a CHIEF update" do
      include FakeFS::SpecHelpers

      let(:path) { "/taric/KBT009(10001).txt" }
      let(:url) { "#{TariffSynchronizer.host}/taric/KBT009(10001).txt" }
      let(:filename) { "2010-01-01_KBT009(10001).txt" }

      before { FileUtils.mkdir_p("#{root_path}/chief/") }

      it "Makes a request to get the file contents" do
        stub = stub_request(:get, url).to_return(status: 200)
        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        expect(stub).to have_been_requested
      end

      it "Creates an entry with failed status when request is 404 and in the future" do
        stub_request(:get, url).to_return(status: 404)
        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.filename).to eq("2010-01-01_chief")
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Does not create entry when request is a 404 and is the same day" do
        stub_request(:get, url).to_return(status: 404)

        travel_to date do
          expect do
            DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
          end.to_not change(TariffSynchronizer::ChiefUpdate, :count)
        end
      end

      it "Creates an Update entry with failed status when cvs has bad format" do
        stub_request(:get, url).to_return(status: 200, body: '"x","y')
        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.exception_class).to include("CSV::MalformedCSVError")
      end

      it "Creates an Update entry with pending status" do
        stub_request(:get, url).to_return(status: 200, body: "abc")
        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        update = TariffSynchronizer::ChiefUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("P")
        expect(update.issue_date).to eq(date)
      end

      it "Writes the contents of the CHIEF file locally" do
        stub_request(:get, url).to_return(status: 200, body: "abc")

        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        expect(File).to exist("#{root_path}/chief/#{filename}")
        expect(File.read("#{root_path}/chief/#{filename}")).to eq 'abc'
      end

      it "Creates an Update entry with failed status when response is blank" do
        stub_request(:get, url).to_return(status: 200, body: "")
        DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        update = TariffSynchronizer::ChiefUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Raises an exception if response is not 200 or 404" do
        stub_request(:get, url).to_return(status: 403)

        expect do
          DownloadUpdatesWorker.new.perform(filename, path, string_date, :chief)
        end.to raise_error(RuntimeError, "Invalid Status")
      end

      it "Creates an Update entry with failed status when all retries fail" do

        # Begin: Trigger the sidekiq_retries_exhausted block
        params = { 'class' => 'DownloadUpdatesWorker',
                    'args' => [filename, path, string_date, :chief],
                    'retry_count' => 0, 'retry' => 1, 'dead' => false }
        expect do
          Sidekiq::Middleware::Server::RetryJobs.new.call(DownloadUpdatesWorker.new, params, 'default') do
            raise "Invalid Status"
          end
        end.to raise_error(RuntimeError)
        # End

        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end
    end
  end
end
