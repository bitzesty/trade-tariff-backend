require "rails_helper"
require "sidekiq/middleware/server/retry_jobs"

describe DownloadUpdatesWorker do
  let(:string_date) { "2010-01-01" }
  let(:date) { Date.parse(string_date) }
  let(:root_path) { TariffSynchronizer.root_path }

  describe "#perform" do
    include FakeFS::SpecHelpers

    context "Downloading a CHIEF update" do
      let(:path) { "/taric/KBT009(10001).txt" }
      let(:url) { "#{TariffSynchronizer.host}/taric/KBT009(10001).txt" }
      let(:filename) { "2010-01-01_KBT009(10001).txt" }

      before { FileUtils.mkdir_p("#{root_path}/chief/") }

      it "Makes a request to get the file contents" do
        stub = stub_request(:get, url).to_return(status: 200)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        expect(stub).to have_been_requested
      end

      it "Creates an entry with failed status when request is 404 and in the future" do
        stub_request(:get, url).to_return(status: 404)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.filename).to eq("2010-01-01_chief")
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Does not create entry when request is a 404 and is the same day" do
        stub_request(:get, url).to_return(status: 404)

        travel_to date do
          expect do
            DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
          end.to_not change(TariffSynchronizer::ChiefUpdate, :count)
        end
      end

      it "Creates an Update entry with failed status when cvs has bad format" do
        stub_request(:get, url).to_return(status: 200, body: '"x","y')
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.exception_class).to include("CSV::MalformedCSVError")
      end

      it "Creates an Update entry with pending status" do
        stub_request(:get, url).to_return(status: 200, body: "abc")
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        update = TariffSynchronizer::ChiefUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("P")
        expect(update.issue_date).to eq(date)
      end

      it "Writes the contents of the CHIEF file locally" do
        stub_request(:get, url).to_return(status: 200, body: "abc")

        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        expect(File).to exist("#{root_path}/chief/#{filename}")
        expect(File.read("#{root_path}/chief/#{filename}")).to eq 'abc'
      end

      it "Creates an Update entry with failed status when response is blank" do
        stub_request(:get, url).to_return(status: 200, body: "")
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        update = TariffSynchronizer::ChiefUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Raises an exception if response is not 200 or 404" do
        stub_request(:get, url).to_return(status: 403)

        expect do
          DownloadUpdatesWorker.new.perform(string_date, path, filename, :chief)
        end.to raise_error(RuntimeError, "Invalid Status")
      end

      it "Creates an Update entry with failed status when all retries fail" do

        # Trigger the sidekiq_retries_exhausted block
        params = { 'class' => 'DownloadUpdatesWorker',
                    'args' => [string_date, path, filename, :chief],
                    'retry_count' => 0, 'retry' => 1, 'dead' => false }
        expect do
          Sidekiq::Middleware::Server::RetryJobs.new.call(DownloadUpdatesWorker.new, params, 'default') do
            raise "Invalid Status"
          end
        end.to raise_error(RuntimeError)

        update = TariffSynchronizer::ChiefUpdate.last
        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end
    end

    context "Downloading a TARIC update" do
      let(:path) { "/taric/TGB101.xml" }
      let(:url) { "#{TariffSynchronizer.host}/taric/TGB101.xml" }
      let(:filename) { "2010-01-01_TGB101.xml" }
      let(:xml) { %{<top name="sample"><middle name="second"></middle></top>} }

      before { FileUtils.mkdir_p("#{root_path}/taric/") }

      it "Makes a request to get the file contents" do
        stub = stub_request(:get, url).to_return(status: 200)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        expect(stub).to have_been_requested
      end

      it "Creates an entry with failed status when request is 404 and in the future" do
        stub_request(:get, url).to_return(status: 404)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        update = TariffSynchronizer::TaricUpdate.last
        expect(update.filename).to eq("2010-01-01_taric")
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Does not create entry when request is a 404 and is the same day" do
        stub_request(:get, url).to_return(status: 404)

        travel_to date do
          expect do
            DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
          end.to_not change(TariffSynchronizer::TaricUpdate, :count)
        end
      end

      it "Creates an Update entry with failed status when cvs has bad format" do
        bad_xml = %{<top name="sample"><middle name="second"</middle></top>}
        stub_request(:get, url).to_return(status: 200, body: bad_xml)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        update = TariffSynchronizer::TaricUpdate.last
        expect(update.exception_class).to include("Ox::ParseError")
      end

      it "Creates an Update entry with pending status" do
        stub_request(:get, url).to_return(status: 200, body: xml)
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        update = TariffSynchronizer::TaricUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("P")
        expect(update.issue_date).to eq(date)
      end

      it "Writes the contents of the TARIC file locally" do
        stub_request(:get, url).to_return(status: 200, body: xml)

        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        expect(File).to exist("#{root_path}/taric/#{filename}")
        expect(File.read("#{root_path}/taric/#{filename}")).to eq xml
      end

      it "Creates an Update entry with failed status when response is blank" do
        stub_request(:get, url).to_return(status: 200, body: "")
        DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        update = TariffSynchronizer::TaricUpdate.last

        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end

      it "Raises an exception if response is not 200 or 404" do
        stub_request(:get, url).to_return(status: 403)

        expect do
          DownloadUpdatesWorker.new.perform(string_date, path, filename, :taric)
        end.to raise_error(RuntimeError, "Invalid Status")
      end

      it "Creates an Update entry with failed status when all retries fail" do

        # Trigger the sidekiq_retries_exhausted block
        params = { 'class' => 'DownloadUpdatesWorker',
                    'args' => [string_date, path, filename, :taric],
                    'retry_count' => 0, 'retry' => 1, 'dead' => false }
        expect do
          Sidekiq::Middleware::Server::RetryJobs.new.call(DownloadUpdatesWorker.new, params, 'default') do
            raise "Invalid Status"
          end
        end.to raise_error(RuntimeError)

        update = TariffSynchronizer::TaricUpdate.last
        expect(update.filename).to eq(filename)
        expect(update.state).to eq("F")
        expect(update.issue_date).to eq(date)
      end
    end
  end
end
