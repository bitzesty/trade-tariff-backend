require "rails_helper"

describe TariffSynchronizer::BaseUpdateImporter do

  let(:taric_update) { create :taric_update, :pending }
  let(:base_update_importer) { described_class.new(taric_update) }

  describe "#apply", truncation: true do
    it "calls the import! method to the object"do
      expect(taric_update).to receive(:import!).and_return(true)
      base_update_importer.apply
    end

    it "do not call the import! method to the object if is not pending"do
      taric_update.mark_as_failed

      expect(taric_update).to_not receive(:import!)
      base_update_importer.apply
    end

    it "marks the record as failed if an error occurs" do
      allow(taric_update).to receive(:import!).and_raise(Sequel::Rollback)
      base_update_importer.apply

      expect(taric_update.reload).to be_failed
    end

    it "updates the record with the exception if an error occurs" do
      expect { base_update_importer.apply }.to raise_error(Sequel::Error)

      expect(taric_update.reload).to be_failed
      expect(taric_update.exception_backtrace).to include("lib/taric_importer.rb:")
      expect(taric_update.exception_queries).to include("(Sequel::Postgres::Database) ROLLBACK")
    end

    it "logs error message and sends an email" do
      tariff_synchronizer_logger_listener

      expect { base_update_importer.apply }.to raise_error(Sequel::Error)

      expect(@logger.logged(:error).size).to eq(1)
      expect(@logger.logged(:error).last).to include("Update failed: ")

      expect(ActionMailer::Base.deliveries).to_not be_empty
      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("Failed Trade Tariff update")
      expect(email.encoded).to include("Backtrace")
      expect(email.encoded).to include("(Sequel::Postgres::Database) ROLLBACK")
    end
  end
end
