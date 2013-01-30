require 'spec_helper'
require 'chief_transformer'
require 'active_support/log_subscriber/test_helper'

describe ChiefTransformer::Logger do
  include ActiveSupport::LogSubscriber::TestHelper

  before {
    setup # ActiveSupport::LogSubscriber::TestHelper.setup

    ChiefTransformer::Logger.attach_to :chief_transformer
    ChiefTransformer::Logger.logger = @logger
  }

  describe '#start_transform logging' do
    before { ChiefTransformer.instance.invoke }

    it 'logs an info event' do
      @logger.logged(:info).size.should be >= 1
      @logger.logged(:info).first.should =~ /CHIEF Transformer started/
    end
  end

  describe '#transform logging' do
    before { ChiefTransformer.instance.invoke }

    context 'transformation with errors' do
      let!(:tame)    { create :tame, :unprocessed }
      let!(:measure) { create :measure }

      before {
        Chief::Tame.any_instance.expects(:mark_as_processed!)
            .raises(Sequel::ValidationFailed.new(measure))

        rescuing { ChiefTransformer.instance.invoke }
      }

      it 'logs an error event' do
        @logger.logged(:error).size.should eq 1
        @logger.logged(:error).last.should =~ /Could not transform/i
      end

      it 'sends an error email' do
        ActionMailer::Base.deliveries.should_not be_empty
        email = ActionMailer::Base.deliveries.last
        email.encoded.should =~ /invalid CHIEF operation/
      end
    end
  end

  describe '#process logging' do
    let!(:tame) { create :tame }

    context 'successful process' do
      before { ChiefTransformer.instance.invoke }

      it 'logs an info event' do
        @logger.logged(:info).size.should be >= 1
        @logger.logged(:info)[1].should =~ /processed/i
      end
    end
  end
end
