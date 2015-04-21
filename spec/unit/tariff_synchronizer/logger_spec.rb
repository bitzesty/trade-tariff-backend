require 'rails_helper'
require 'tariff_synchronizer'
require 'active_support/log_subscriber/test_helper'

describe TariffSynchronizer::Logger, truncation: true do
  include ActiveSupport::LogSubscriber::TestHelper

  before(:all) { WebMock.disable_net_connect! }
  after(:all)  { WebMock.allow_net_connect! }

  before {
    setup # ActiveSupport::LogSubscriber::TestHelper.setup

    allow_any_instance_of(
      TariffSynchronizer::Logger
    ).to receive(:logger).and_return(@logger)
    TariffSynchronizer::Logger.attach_to :tariff_synchronizer
  }

  describe '#download logging' do
    before {
      expect(TariffSynchronizer::TaricUpdate).to receive(:sync).and_return(true)
      expect(TariffSynchronizer::ChiefUpdate).to receive(:sync).and_return(true)
      expect(TariffSynchronizer).to receive(:sync_variables_set?).and_return(true)

      TariffSynchronizer.download
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Finished downloading/
    end
  end

  describe '#config_error logging' do
    before {
      expect(TariffSynchronizer).to receive(:sync_variables_set?).and_return(false)

      TariffSynchronizer.download
    }

    it 'logs an info event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /Missing/
    end
  end

  describe '#failed_updates_present logging' do
    let(:update_stubs) { double(any?: true, map: []).as_null_object }

    before {
      allow(
        TariffSynchronizer::BaseUpdate
      ).to receive(:failed).and_return(update_stubs)

      expect { TariffSynchronizer.apply }.to raise_error TariffSynchronizer::FailedUpdatesError
    }

    it 'logs and error event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /found failed updates/
    end

    it 'sends email error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /File names/
    end
  end

  describe '#apply logging' do
    context 'pending update present' do
      let(:example_date)  { Date.today }
      let!(:taric_update) { create :taric_update, example_date: example_date }

      before {
        prepare_synchronizer_folders
        create_taric_file :pending, example_date

        Footnote.unrestrict_primary_key

        # Do not use default FootnoteValidator validations, we
        # need a permissive validator here
        class PermissiveFootnoteValidator < TradeTariffBackend::Validator
        end

        Footnote.conformance_validator = PermissiveFootnoteValidator.new

        TariffSynchronizer.apply
      }

      after  {
        purge_synchronizer_folders

        Footnote.conformance_validator = nil
      }

      it 'logs and info event' do
        expect(@logger.logged(:info).size).to  be > 0
        expect(@logger.logged(:info).last).to  match /Finished applying/
      end

      it 'sends success email' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.encoded).to  match /successfully applied/
        expect(email.encoded).to  match /#{taric_update.filename}/
      end

      it 'informs that no conformance errors were found' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.encoded).to  match /No conformance errors found/
      end
    end

    context 'no pending updates present' do
      before {
        ActionMailer::Base.deliveries = []
        TariffSynchronizer.apply
      }

      it 'logs and info event' do
        expect(@logger.logged(:info).size).to  eq 0
      end

      it 'does not send success email' do
        expect(ActionMailer::Base.deliveries).to  be_empty
      end
    end

    context 'update contains entries with conformance errors' do
      let(:example_date)  { Date.today }
      let!(:taric_update) { create :taric_update, example_date: example_date }

      before {
        prepare_synchronizer_folders
        create_taric_file :pending, example_date

        Footnote.unrestrict_primary_key

        invalid_measure = build(:measure,
          justification_regulation_id: "123",
          justification_regulation_role: "123",
          validity_start_date: Date.today,
          validity_end_date: Date.today.ago(1.year)
        )

        TariffSynchronizer.apply
      }

      after {
        purge_synchronizer_folders
      }

      it 'logs and info event' do
        expect(@logger.logged(:info).size).to  be > 1
      end

      it 'sends email with conformance error descriptions' do
        expect(ActionMailer::Base.deliveries).to_not be_empty

        last_email_content = ActionMailer::Base.deliveries.last.encoded
        expect(last_email_content).to_not match /No conformance errors found/
        expect(last_email_content).to  match /less than or equal to the end date/
      end
    end
  end

  describe '#failed_update logging' do
    let(:example_date)  { Date.today }
    let!(:taric_update) { create :taric_update, example_date: example_date }

    let(:last_email_body) {
      ActionMailer::Base.deliveries.last.encoded
    }

    before {
      allow_any_instance_of(TariffImporter).to receive(:file_exists?).and_return true
      allow_any_instance_of(TariffSynchronizer::BaseUpdate).to receive(:file_exists?).and_return true
      allow_any_instance_of(TaricImporter).to receive(:import) {
        Measure.first
        raise TaricImporter::ImportException
      }

      rescuing {
        TariffSynchronizer.apply
      }
    }

    it 'logs and info event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /Update failed/
    end

    it 'sends email error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      expect(last_email_body).to match /Backtrace/
    end

    it 'email includes information about original exception' do
      expect(last_email_body).to match /TaricImporter::ImportException/
    end

    it 'email include executed SQL queries' do
      expect(last_email_body).to match /SELECT \* FROM/
    end

    it "stores exception" do
      expect(taric_update.reload.exception_backtrace).to_not be_nil
      expect(taric_update.reload.exception_class).to_not be_nil
      expect(taric_update.reload.exception_queries).to_not be_nil
    end
  end

  describe '#failed_download logging' do
    before {
      TariffSynchronizer.retry_count = 0
      TariffSynchronizer.exception_retry_count = 0
      allow(TariffSynchronizer).to receive(:sync_variables_set?).and_return(true)

      allow_any_instance_of(Curl::Easy).to receive(:perform)
                                       .and_raise(Curl::Err::HostResolutionError)

      rescuing { TariffSynchronizer.download }
    }

    it 'logs and info event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /Download failed/
    end

    it 'sends email error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /Backtrace/
    end

    it 'email includes information about exception' do
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /Curl::Err::HostResolutionError/
    end
  end

  describe '#rebuild logging' do
    before {
      expect(TariffSynchronizer::TaricUpdate).to receive(:rebuild).and_return(true)
      expect(TariffSynchronizer::ChiefUpdate).to receive(:rebuild).and_return(true)

      TariffSynchronizer.rebuild
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Rebuilding/
    end
  end

  describe '#retry_exceeded logging' do
    let(:failed_response) { build :response, :retry_exceeded }

    before {
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content).and_return(failed_response)

      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs a warning event' do
      expect(@logger.logged(:warn).size).to eq 1
      expect(@logger.logged(:warn).last).to match /Download retry/
    end

    it 'sends a warning email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /Retry count exceeded/
    end
  end

  describe '#not_found logging' do
    let(:not_found_response) { build :response, :not_found }

    before {
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content).and_return(not_found_response)

      TariffSynchronizer::ChiefUpdate.download(Date.yesterday)
    }

    it 'logs a warning event' do
      expect(@logger.logged(:warn).size).to eq 1
      expect(@logger.logged(:warn).last).to match /Update not found/
    end
  end

  describe '#not_found_on_file_system logging' do
    let(:taric_update) { create :taric_update }

    before {
      expect(TariffSynchronizer::TaricUpdate).to receive(:download)
                                     .with(taric_update.issue_date)
                                     .and_return(true)
    }

    context "errors" do
      before { taric_update.file_exists? }

      it 'logs an error event' do
        expect(@logger.logged(:error).size).to eq 1
        expect(@logger.logged(:error).last).to match /Update not found on file system/
      end

      it 'sends error email' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.encoded).to match /was not found/
      end
    end

    context "applies the update" do
      it {
        expect {
          taric_update.apply
        }.to raise_error(Sequel::Rollback)
      }
    end
  end

  describe '#download_chief logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content).and_return(success_response)
      # Do not write file to file system
      expect(TariffSynchronizer::ChiefUpdate).to receive(:create_entry).and_return(true)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Downloaded CHIEF update/
    end
  end

  describe '#apply_chief logging' do
    let(:chief_update) { create :chief_update }

    before {
      # Test in isolation, file is not actually in the file system
      # so bypass the check
      expect(File).to receive(:exists?)
                  .with(chief_update.file_path)
                  .twice
                  .and_return(true)

      rescuing {
        chief_update.apply
      }
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Applied CHIEF update/
    end
  end

  describe '#download_taric logging' do
    let(:success_response) { build :response, :success }
    let(:query_response) { build :response, :success, :content => 'file_name', :url => 'url' }

    before {
      # Skip Taric update file name fetching
      expect(TariffSynchronizer::TaricUpdate).to receive(:taric_update_name_for).and_return(
        query_response
      )
      # Download mock response
      expect(TariffSynchronizer::TaricUpdate).to receive(:download_content).and_return(success_response)
      # Do not write file to file system
      expect(TariffSynchronizer::TaricUpdate).to receive(:create_entry).and_return(true)
      # Actual Download
      TariffSynchronizer::TaricUpdate.download(Date.today)
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Downloaded TARIC update/
    end
  end

  describe '#apply_taric logging' do
    let(:taric_update) { create :taric_update }

    before {
      # Test in isolation, file is not actually in the file system
      # so bypass the check
      expect(File).to receive(:exists?)
                  .with(taric_update.file_path)
                  .twice
                  .and_return(true)

      rescuing {
        taric_update.apply
      }
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Applied TARIC update/
    end
  end

  describe '#get_taric_update_name logging' do
    let(:not_found_response) { build :response, :not_found }

    before {
      expect(TariffSynchronizer::TaricUpdate).to receive(:download_content).and_return(not_found_response)
      TariffSynchronizer::TaricUpdate.download(Date.today)
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).first).to match /Checking for TARIC update/
    end
  end

  describe '#update_written logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content).and_return(success_response)
      # Do not write file to file system
      expect(TariffSynchronizer::ChiefUpdate).to receive(:write_file).and_return(true)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 2
      expect(@logger.logged(:info).first).to match /Update file written to/
    end
  end

  describe '#blank_update logging' do
    let(:blank_response) { build :response, :blank }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                             .and_return(blank_response)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).first).to match /Blank update content/
    end

    it 'sends and error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /blank file/
    end
  end

  describe '#cant_open_file logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                             .and_return(success_response)

      # Simulate I/O exception
      expect(File).to receive(:open).and_raise(Errno::ENOENT)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).first).to match /for writing/
    end

    it 'sends and error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /open for writing/
    end
  end

  describe '#cant_write_to_file logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                             .and_return(success_response)
      # Simulate I/O exception
      expect(File).to receive(:open).and_raise(IOError)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).first).to match /write to update file/
    end

    it 'sends and error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /write to file/
    end
  end

  describe '#write_permission_error logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      expect(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                             .and_return(success_response)
      # Simulate I/O exception
      expect(File).to receive(:open).and_raise(Errno::EACCES)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).first).to match /No permission/
    end

    it 'sends and error email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /permission error/
    end
  end

  describe '#delay_download logging' do
    let(:failed_response)  { build :response, :failed }
    let(:success_response) { build :response, :success }

    before {
      TariffSynchronizer.retry_count = 10
      expect(TariffSynchronizer::ChiefUpdate).to receive(:send_request)
                                             .exactly(3).times
                                             .and_return(failed_response, failed_response, success_response)
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to be >= 1
      expect(@logger.logged(:info).to_s).to match /Delaying update fetching/
    end
  end

  describe '#missing_updates' do
    let(:not_found_response) { build :response, :not_found }
    let!(:chief_update1) { create :chief_update, :missing, issue_date: Date.today.ago(2.days) }
    let!(:chief_update2) { create :chief_update, :missing, issue_date: Date.today.ago(3.days) }

    before {
      allow(TariffSynchronizer::ChiefUpdate).to receive(:download_content)
                                            .and_return(not_found_response)
      TariffSynchronizer::ChiefUpdate.sync
    }

    it 'logs a warn event' do
      expect(@logger.logged(:warn).size).to be > 1
      expect(@logger.logged(:warn).to_s).to match /Missing/
    end

    it 'sends a warning email' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.encoded).to match /missing/
    end
  end
  describe "#rollback_lock_error" do
    before {
       expect(TradeTariffBackend).to receive(
        :with_redis_lock).and_raise(RedisLock::LockTimeout)

       TariffSynchronizer.rollback(Date.today, true)
    }

    it 'logs a warn event' do
      expect(@logger.logged(:warn).size).to be >= 1
      expect(@logger.logged(:warn).first.to_s).to match /acquire Redis lock/
    end
  end

  describe "#apply_lock_error" do
    before {
       expect(TradeTariffBackend).to receive(
        :with_redis_lock).and_raise(RedisLock::LockTimeout)

       TariffSynchronizer.apply
    }

    it 'logs a warn event' do
      expect(@logger.logged(:warn).size).to be >= 1
      expect(@logger.logged(:warn).first.to_s).to match /acquire Redis lock/
    end
  end
end
