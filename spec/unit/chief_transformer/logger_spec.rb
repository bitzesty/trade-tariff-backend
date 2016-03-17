require 'rails_helper'
require 'chief_transformer'

describe ChiefTransformer::Logger do
  before { chief_transformer_logger_listener }

  describe '#start_transform logging' do
    before { ChiefTransformer.instance.invoke }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to be >= 1
      expect(@logger.logged(:info).first).to match /CHIEF Transformer started/
    end
  end

  describe '#transform logging' do
    before { ChiefTransformer.instance.invoke }

    context 'transformation with errors' do
      let!(:tame)    { create :tame, :unprocessed }
      let!(:measure) { create :measure }

      before {
        allow_any_instance_of(
          Chief::Tame
        ).to receive(:mark_as_processed!)
        .and_raise(Sequel::ValidationFailed.new(measure))

        rescuing { ChiefTransformer.instance.invoke }
      }

      it 'logs an error event' do
        expect(@logger.logged(:error).size).to eq 1
        expect(@logger.logged(:error).last).to match /Could not transform/i
      end

      it 'sends an error email' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.encoded).to match /invalid CHIEF operation/
      end
    end
  end

  describe '#process logging' do
    let!(:tame) { create :tame }

    context 'successful process' do
      before { ChiefTransformer.instance.invoke }

      it 'logs an info event' do
        expect(@logger.logged(:info).size).to be >= 1
        expect(@logger.logged(:info)[1]).to match /processed/i
      end
    end
  end
end
