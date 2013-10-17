require 'spec_helper'
require 'tariff_synchronizer'
require 'active_support/log_subscriber/test_helper'

describe TariffSynchronizer::Logger do
  include ActiveSupport::LogSubscriber::TestHelper

  before(:all) { WebMock.disable_net_connect! }
  after(:all)  { WebMock.allow_net_connect! }

  before {
    setup # ActiveSupport::LogSubscriber::TestHelper.setup

    TariffSynchronizer::Logger.attach_to :tariff_synchronizer
    TariffSynchronizer::Logger.logger = @logger
  }

  describe '#download logging' do
    before {
      TariffSynchronizer::TaricUpdate.should_receive(:sync).and_return(true)
      TariffSynchronizer::ChiefUpdate.should_receive(:sync).and_return(true)
      TariffSynchronizer.should_receive(:sync_variables_set?).and_return(true)

      TariffSynchronizer.download
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Finished downloading/
    end
  end

  describe '#config_error logging' do
    before {
      TariffSynchronizer.should_receive(:sync_variables_set?).and_return(false)

      TariffSynchronizer.download
    }

    it 'logs an info event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Missing/
    end
  end

  describe '#failed_updates_present logging' do
    let(:update_stubs) { double(any?: true, map: []).as_null_object }

    before {
      TariffSynchronizer::BaseUpdate.stub(:failed).and_return(update_stubs)

      TariffSynchronizer.apply
    }

    it 'logs and error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /found failed updates/
    end

    it 'sends email error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /File names/
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
        @logger.logged(:info).size.should be > 0
        @logger.logged(:info).last.should =~ /Finished applying/
      end

      it 'sends success email' do
        ActionMailer::Base.deliveries.should_not be_empty
        email = ActionMailer::Base.deliveries.last
        email.encoded.should =~ /successfully applied/
        email.encoded.should =~ /#{taric_update.filename}/
      end

      it 'informs that no conformance errors were found' do
        ActionMailer::Base.deliveries.should_not be_empty
        email = ActionMailer::Base.deliveries.last
        email.encoded.should =~ /No conformance errors found/
      end
    end

    context 'no pending updates present' do
      before {
        ActionMailer::Base.deliveries = []
        TariffSynchronizer.apply
      }

      it 'logs and info event' do
        @logger.logged(:info).size.should eq 0
      end

      it 'does not send success email' do
        ActionMailer::Base.deliveries.should be_empty
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
                                validity_end_date: Date.today.ago(1.year))

        TariffSynchronizer.apply
      }

      after {
        purge_synchronizer_folders
      }

      it 'logs and info event' do
        @logger.logged(:info).size.should be > 1
      end

      it 'sends email with conformance error descriptions' do
        ActionMailer::Base.deliveries.should_not be_empty

        last_email_content = ActionMailer::Base.deliveries.last.encoded
        last_email_content.should_not =~ /No conformance errors found/
        last_email_content.should =~ /less than or equal to the end date/
      end
    end
  end

  describe '#failed_update logging' do
    let(:mock_pending_update) { double(file_name: Date.today,
                                       update_priority: 1,
                                       file_path: '/').as_null_object }

    let(:last_email_body) {
      ActionMailer::Base.deliveries.last.encoded
    }

    before {
      class MockException < StandardError
        def backtrace
          []
        end
      end

      mock_pending_update.should_receive(:apply) {
        Measure.first # execute dummy query to check if it was logged and presented in email
        raise TaricImporter::ImportException.new("", MockException.new)
      }

      TariffSynchronizer::PendingUpdate.should_receive(:all).and_return([mock_pending_update])
      rescuing {
        TariffSynchronizer.apply
      }
    }

    it 'logs and info event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Update failed/
    end

    it 'sends email error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      last_email_body.should =~ /Backtrace/
    end

    it 'email includes information about original exception' do
      last_email_body.should =~ /MockException/
    end

    it 'email include executed SQL queries' do
      last_email_body.should =~ /SELECT \* FROM/
    end
  end

  describe '#failed_download logging' do
    before {
       TariffSynchronizer.retry_count = 0
       TariffSynchronizer.stub(:sync_variables_set?).and_return(true)

       Curl::Easy.any_instance
                 .should_receive(:perform)
                 .and_raise(Curl::Err::HostResolutionError)

      rescuing { TariffSynchronizer.download }
    }

    it 'logs and info event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Download failed/
    end

    it 'sends email error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /Backtrace/
    end

    it 'email includes information about exception' do
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /Curl::Err::HostResolutionError/
    end
  end

  describe '#rebuild logging' do
    before {
      TariffSynchronizer::TaricUpdate.should_receive(:rebuild).and_return(true)
      TariffSynchronizer::ChiefUpdate.should_receive(:rebuild).and_return(true)

      TariffSynchronizer.rebuild
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Rebuilding/
    end
  end

  describe '#retry_exceeded logging' do
    let(:failed_response) { build :response, :retry_exceeded }

    before {
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content).and_return(failed_response)

      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs a warning event' do
      @logger.logged(:warn).size.should eq 1
      @logger.logged(:warn).last.should =~ /Download retry/
    end

    it 'sends a warning email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /Retry count exceeded/
    end
  end

  describe '#not_found logging' do
    let(:not_found_response) { build :response, :not_found }

    before {
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content).and_return(not_found_response)

      TariffSynchronizer::ChiefUpdate.download(Date.yesterday)
    }

    it 'logs a warning event' do
      @logger.logged(:warn).size.should eq 1
      @logger.logged(:warn).last.should =~ /Update not found/
    end
  end

  describe '#not_found_on_file_system logging' do
    let(:taric_update) { create :taric_update }

    before { taric_update.apply }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Update not found on file system/
    end

    it 'sends error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /was not found/
    end
  end

  describe '#download_chief logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content).and_return(success_response)
      # Do not write file to file system
      TariffSynchronizer::ChiefUpdate.should_receive(:create_entry).and_return(true)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Downloaded CHIEF update/
    end
  end

  describe '#apply_chief logging' do
    let(:chief_update) { create :chief_update }

    before {
      # Test in isolation, file is not actually in the file system
      # so bypass the check
      File.should_receive(:exists?)
          .with(chief_update.file_path)
          .twice
          .and_return(true)

      rescuing {
        chief_update.apply
      }
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Applied CHIEF update/
    end
  end

  describe '#download_taric logging' do
    let(:success_response) { build :response, :success }

    before {
      # Skip Taric update file name fetching
      TariffSynchronizer::TaricUpdate.should_receive(:taric_updates_for).and_return(
        [OpenStruct.new(url: 'url', file_name: 'file_name')]
      )
      # Download mock response
      TariffSynchronizer::TaricUpdate.should_receive(:download_content).and_return(success_response)
      # Do not write file to file system
      TariffSynchronizer::TaricUpdate.should_receive(:create_entry).and_return(true)
      # Actual Download
      TariffSynchronizer::TaricUpdate.download(Date.today)
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Downloaded TARIC update/
    end
  end

  describe '#apply_taric logging' do
    let(:taric_update) { create :taric_update }

    before {
      # Test in isolation, file is not actually in the file system
      # so bypass the check
      File.should_receive(:exists?)
          .with(taric_update.file_path)
          .twice
          .and_return(true)

      rescuing {
        taric_update.apply
      }
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Applied TARIC update/
    end
  end

  describe '#get_taric_update_name logging' do
    let(:not_found_response) { build :response, :not_found }

    before {
      TariffSynchronizer::TaricUpdate.should_receive(:download_content).and_return(not_found_response)
      TariffSynchronizer::TaricUpdate.download(Date.today)
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).first.should =~ /Checking for TARIC update/
    end
  end

  describe '#update_written logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content).and_return(success_response)
      # Do not write file to file system
      TariffSynchronizer::ChiefUpdate.should_receive(:write_file).and_return(true)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 2
      @logger.logged(:info).first.should =~ /Update file written to/
    end
  end

  describe '#blank_update logging' do
    let(:blank_response) { build :response, :blank }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                     .and_return(blank_response)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).first.should =~ /Blank update content/
    end

    it 'sends and error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /blank file/
    end
  end

  describe '#cant_open_file logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                     .and_return(success_response)
      # Simulate I/O exception
      File.should_receive(:open).and_raise(Errno::ENOENT)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).first.should =~ /for writing/
    end

    it 'sends and error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /open for writing/
    end
  end

  describe '#cant_write_to_file logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                     .and_return(success_response)
      # Simulate I/O exception
      File.should_receive(:open).and_raise(IOError)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).first.should =~ /write to update file/
    end

    it 'sends and error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /write to file/
    end
  end

  describe '#write_permission_error logging' do
    let(:success_response) { build :response, :success }

    before {
      # Download mock response
      TariffSynchronizer::ChiefUpdate.should_receive(:download_content)
                                     .and_return(success_response)
      # Simulate I/O exception
      File.should_receive(:open).and_raise(Errno::EACCES)
      # Actual Download
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).first.should =~ /No permission/
    end

    it 'sends and error email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /permission error/
    end
  end

  describe '#delay_download logging' do
    let(:failed_response)  { build :response, :failed }
    let(:success_response) { build :response, :success }

    before {
      TariffSynchronizer.retry_count = 10
      TariffSynchronizer::ChiefUpdate.should_receive(:send_request)
                                     .exactly(3).times
                                     .and_return(failed_response, failed_response, success_response)
      TariffSynchronizer::ChiefUpdate.download(Date.today)
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should be >= 1
      @logger.logged(:info).to_s.should =~ /Delaying update fetching/
    end
  end

  describe '#missing_updates' do
    let(:not_found_response) { build :response, :not_found }
    let!(:chief_update1) { create :chief_update, :missing, issue_date: Date.today.ago(2.days) }
    let!(:chief_update2) { create :chief_update, :missing, issue_date: Date.today.ago(3.days) }

    before {
      TariffSynchronizer::ChiefUpdate.stub(:download_content)
                                     .and_return(not_found_response)
      TariffSynchronizer::ChiefUpdate.sync
    }

    it 'logs a warn event' do
      @logger.logged(:warn).size.should be > 1
      @logger.logged(:warn).to_s.should =~ /Missing/
    end

    it 'sends a warning email' do
      ActionMailer::Base.deliveries.should_not be_empty
      email = ActionMailer::Base.deliveries.last
      email.encoded.should =~ /missing/
    end
  end
end
