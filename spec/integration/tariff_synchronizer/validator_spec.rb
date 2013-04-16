require 'spec_helper'

describe TariffSynchronizer::Validator do
  describe '.invalid_entries_for' do
    let(:update)          { stub(affected_datasets: [Measure.dataset,
                                                     Footnote.dataset] ) }
    let!(:measure)        { create :measure, measure_sid: 1 }
    let!(:footnote)       { create :footnote }

    before {
      # cannot set validity end date without setting justification regulation
      # role and id (ME33, ME34)
      measure.validity_end_date = Date.today
      measure.save(validate: false)
    }

    it 'returns nested conformance errors of provided update' do
      invalid_entries = TariffSynchronizer::Validator.invalid_entries_for(update)

      invalid_entries.should have_key Measure
      invalid_entries[Measure].keys.should include 1
    end
  end
end
