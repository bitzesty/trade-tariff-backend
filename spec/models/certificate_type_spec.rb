require 'spec_helper'

describe CertificateType do
  describe 'validations' do
    # CET1: certificate_type_id
    it { should validate_uniqueness.of :certificate_type_code }
    # CET3: validity_dates
    it { should validate_validity_dates }

    describe 'CET2' do
      let!(:certificate_type) { create :certificate_type }
      let!(:certificate)      { create :certificate, certificate_type_code: certificate_type.certificate_type_code }

      specify 'The certificate type cannot be deleted if it is used in a certificate.' do
        expect { certificate_type.destroy }.to raise_error Sequel::HookFailed
      end
    end
  end
end
