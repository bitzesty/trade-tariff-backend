require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::Logger, truncation: true do
  before(:all) { WebMock.disable_net_connect! }
  after(:all)  { WebMock.allow_net_connect! }

  before { tariff_synchronizer_logger_listener }

  describe '#missing_updates' do
    let(:not_found_response) { build :response, :not_found }
    before {
      create :chief_update, :missing, issue_date: Date.today.ago(2.days)
      create :chief_update, :missing, issue_date: Date.today.ago(3.days)
      allow(TariffSynchronizer::TariffUpdatesRequester).to receive(:perform)
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
