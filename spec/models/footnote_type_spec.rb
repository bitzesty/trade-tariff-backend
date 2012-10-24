require 'spec_helper'

describe FootnoteType do
  describe 'validations' do
    # FOT1: footnote_type_id
    it { should validate_uniqueness_of :footnote_type_id }
    # FOT2: associated footnotes
    it { should validate_associated(:footnotes).on(:destroy) }
    # FOT3: validity_dates
    it { should validate_validity_dates }
  end
end
