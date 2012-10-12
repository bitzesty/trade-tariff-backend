require 'spec_helper'

describe Certificate do
  describe 'associations' do
    describe 'certificate description' do
      let!(:certificate)                { create :certificate }
      let!(:certificate_description1)   { create :certificate_description, :with_period,
                                                            certificate_type_code: certificate.certificate_type_code,
                                                            certificate_code: certificate.certificate_code,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil }
      let!(:certificate_description2) { create :certificate_description, :with_period,
                                                            certificate_type_code: certificate.certificate_type_code,
                                                            certificate_code: certificate.certificate_code,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            certificate.certificate_description.primary_key.should == certificate_description1.primary_key
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            certificate.certificate_description.primary_key.should == certificate_description1.primary_key
          end

          TimeMachine.at(3.years.ago) do
            certificate.certificate_description.primary_key.should == certificate_description2.primary_key
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_description)
                        .all
                        .first
                        .certificate_description.primary_key.should == certificate_description1.primary_key
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_description)
                        .all
                        .first
                        .certificate_description.primary_key.should == certificate_description1.primary_key
          end

          TimeMachine.at(3.years.ago) do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_description)
                        .all
                        .first
                        .certificate_description.primary_key.should == certificate_description2.primary_key
          end
        end
      end
    end

    describe 'certificate type' do
      let!(:certificate)        { create :certificate }
      let!(:certificate_type1)   { create :certificate_type, certificate_type_code: certificate.certificate_type_code,
                                                             validity_start_date: 2.years.ago,
                                                             validity_end_date: nil }
      let!(:certificate_type2)   { create :certificate_type, certificate_type_code: certificate.certificate_type_code,
                                                             validity_start_date: 5.years.ago,
                                                             validity_end_date: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            certificate.certificate_type.primary_key.should == certificate_type1.primary_key
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            certificate.certificate_type.primary_key.should == certificate_type1.primary_key
          end

          TimeMachine.at(3.years.ago) do
            certificate.certificate_type.primary_key.should == certificate_type2.primary_key
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_type)
                        .all
                        .first
                        .certificate_type.primary_key.should == certificate_type1.primary_key
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_type)
                        .all
                        .first
                        .certificate_type.primary_key.should == certificate_type1.primary_key
          end

          TimeMachine.at(3.years.ago) do
            Certificate.where(certificate_type_code: certificate.certificate_type_code,
                              certificate_code: certificate.certificate_code)
                        .eager(:certificate_type)
                        .all
                        .first
                        .certificate_type.primary_key.should == certificate_type2.primary_key
          end
        end
      end
    end
  end

  describe 'validations' do
  end
end
