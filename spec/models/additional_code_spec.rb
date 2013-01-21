require 'spec_helper'

describe AdditionalCode do
  describe 'associations' do
    describe 'additional code description' do
      let!(:additional_code)                { create :additional_code }
      let!(:additional_code_description1)   { create :additional_code_description, :with_period,
                                                            additional_code_sid: additional_code.additional_code_sid,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil }
      let!(:additional_code_description2) { create :additional_code_description, :with_period,
                                                            additional_code_sid: additional_code.additional_code_sid,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            additional_code.additional_code_description.pk.should == additional_code_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            additional_code.additional_code_description.pk.should == additional_code_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            additional_code.reload.additional_code_description.pk.should == additional_code_description2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            AdditionalCode.where(additional_code_sid: additional_code.additional_code_sid)
                          .eager(:additional_code_description)
                          .all
                          .first
                          .additional_code_description.pk.should == additional_code_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            AdditionalCode.where(additional_code_sid: additional_code.additional_code_sid)
                          .eager(:additional_code_description)
                          .all
                          .first
                          .additional_code_description.pk.should == additional_code_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            AdditionalCode.where(additional_code_sid: additional_code.additional_code_sid)
                          .eager(:additional_code_description)
                          .all
                          .first
                          .additional_code_description.pk.should == additional_code_description2.pk
          end
        end
      end
    end
  end

  describe 'validations' do
    # ACN1
    it { should validate_uniqueness.of([:additional_code, :additional_code_type_id, :validity_start_date]) }
    # ACN3
    it { should validate_validity_dates }
  end

  describe "#code" do
    let(:additional_code) { build :additional_code }

    it 'returns conjucation of additional code type id and additional code' do
      additional_code.code.should == [additional_code.additional_code_type_id, additional_code.additional_code].join
    end
  end
end
