require 'spec_helper'

describe Footnote do
  describe 'associations' do
    describe 'additional code description' do
      let!(:footnote)                { create :footnote }
      let!(:footnote_description1)   { create :footnote_description, :with_period,
                                                            footnote_id: footnote.footnote_id,
                                                            footnote_type_id: footnote.footnote_type_id,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil }
      let!(:footnote_description2) { create :footnote_description, :with_period,
                                                            footnote_id: footnote.footnote_id,
                                                            footnote_type_id: footnote.footnote_type_id,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            footnote.footnote_description.pk.should == footnote_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            footnote.footnote_description.pk.should == footnote_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            footnote.reload.footnote_description.pk.should == footnote_description2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            Footnote.where(footnote_id: footnote.footnote_id,
                           footnote_type_id: footnote.footnote_type_id)
                          .eager(:footnote_descriptions)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            Footnote.where(footnote_id: footnote.footnote_id,
                           footnote_type_id: footnote.footnote_type_id)
                          .eager(:footnote_descriptions)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            Footnote.where(footnote_id: footnote.footnote_id,
                           footnote_type_id: footnote.footnote_type_id)
                          .eager(:footnote_descriptions)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description2.pk
          end
        end
      end
    end
  end

  describe 'validations' do
    # FO1 The referenced footnote type must exist.
    it { should validate_presence.of(:footnote_type).if(:has_footnote_type_reference?) }
    # FO2 The combination footnote type and code must be unique.
    it { should validate_uniqueness.of([:footnote_id, :footnote_type_id]) }
    # FO3 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
    # FO4 At least one description record is mandatory. The start date of
    # the first description period must be equal to the start date of the
    # footnote. No two associated description periods may have the same
    # start date. The start date must be less than or equal to the end
    # date of the footnote.
    it { should validate_length.of(:footnote_description_periods).minimum(1) }
    it { should validate_associated(:footnote_description_periods).and_ensure(:first_footnote_description_period_is_valid) }
    # FO5 When a footnote is used in a measure the validity period of the
    # footnote must span the validity period of the measure.
    # FO6 When a footnote is used in a goods nomenclature the validity period
    # of the footnote must span the validity period of the association
    # with the goods nomenclature.
    # FO7 When a footnote is used in an Export refund nomenclature code the
    # validity period of the footnote must span the validity period of the
    # association with the Export refund code.
    # FO9 When a footnote is used in an Additional code the validity period
    # of the footnote must span the validity period of the association with
    # the Additional code.
    # FO10 When a footnote is used in a Meursing Table heading the validity
    # period of the footnote must span the validity period of the association
    # with the Meursing heading.
    it { should validate_associated(:measures).and_ensure(:spans_validity_period_of_associations) }
    it { should validate_associated(:goods_nomenclatures).and_ensure(:spans_validity_period_of_associations) }
    it { should validate_associated(:export_refund_nomenclatures).and_ensure(:spans_validity_period_of_associations) }
    it { should validate_associated(:additional_codes).and_ensure(:spans_validity_period_of_associations) }
    it { should validate_associated(:meursing_headings).and_ensure(:spans_validity_period_of_associations) }
    # FO17 The validity period of the footnote type must span the validity
    # period of the footnote.
    it { should validate_associated(:footnote_type).and_ensure(:footnote_type_validity_period_spans_validity_periods) }

    describe 'FO11' do
      let!(:footnote) { create :footnote }
      let!(:measure)  { create :measure }
      let!(:footnote_association_measure) { create :footnote_association_measure, footnote_id: footnote.footnote_id,
                                                                                 footnote_type_id: footnote.footnote_type_id,
                                                                                 measure_sid: measure.measure_sid }

      specify 'When a footnote is used in a measure then the footnote may not be deleted.' do
        expect { footnote.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'FO12' do
      let!(:footnote) { create :footnote }
      let!(:gono)  { create :goods_nomenclature }
      let!(:footnote_association_goods_nomenclature) { create :footnote_association_goods_nomenclature, footnote_id: footnote.footnote_id,
                                                                                 footnote_type: footnote.footnote_type_id,
                                                                                 goods_nomenclature_sid: gono.goods_nomenclature_sid }

      specify 'When a footnote is used in a goods nomenclature then the footnote may not be deleted.' do
        expect { footnote.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'FO13' do
      let!(:footnote) { create :footnote }
      let!(:ern)  { create :export_refund_nomenclature }
      let!(:footnote_association_ern) { create :footnote_association_ern, footnote_id: footnote.footnote_id,
                                                                          footnote_type: footnote.footnote_type_id,
                                                                          export_refund_nomenclature_sid: ern.export_refund_nomenclature_sid }

      specify 'When a footnote is used in an Export Refund code then the footnote may not be deleted.' do
        expect { footnote.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'FO15' do
      let!(:footnote) { create :footnote }
      let!(:adco)  { create :additional_code }
      let!(:footnote_association_additional_code) { create :footnote_association_additional_code, footnote_id: footnote.footnote_id,
                                                                          footnote_type_id: footnote.footnote_type_id,
                                                                          additional_code_sid: adco.additional_code_sid }

      specify 'When a footnote is used in an additional code then the footnote may not be deleted.' do
        expect { footnote.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'FO16' do
      let!(:footnote) { create :footnote }
      let!(:meursing_heading)  { create :meursing_heading }
      let!(:footnote_association_meursing_heading) { create :footnote_association_meursing_heading, footnote_id: footnote.footnote_id,
                                                                          footnote_type: footnote.footnote_type_id,
                                                                          meursing_table_plan_id: meursing_heading.meursing_table_plan_id,
                                                                          meursing_heading_number: meursing_heading.meursing_heading_number }

      specify 'When a footnote is used in a Meursing Table heading then the footnote may not be deleted.' do
        expect { footnote.destroy }.to raise_error Sequel::HookFailed
      end
    end
  end

  describe '#code' do
    let(:footnote) { build :footnote }

    it 'returns conjuction of footnote type id and footnote id' do
      footnote.code.should == [footnote.footnote_type_id, footnote.footnote_id].join
    end
  end
end
