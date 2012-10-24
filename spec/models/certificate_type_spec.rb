require 'spec_helper'

describe CertificateType do
  describe 'validations' do
    # CET1: certificate_type_id
    it { should validate_uniqueness_of :certificate_type_code }
    # CET2: associated certificates
    it { should validate_associated(:certificates).on(:destroy) }
    # CET3: validity_dates
    it { should validate_validity_dates }
  end
end
