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
                          .eager(:footnote_description)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            Footnote.where(footnote_id: footnote.footnote_id,
                           footnote_type_id: footnote.footnote_type_id)
                          .eager(:footnote_description)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            Footnote.where(footnote_id: footnote.footnote_id,
                           footnote_type_id: footnote.footnote_type_id)
                          .eager(:footnote_description)
                          .all
                          .first
                          .footnote_description.pk.should == footnote_description2.pk
          end
        end
      end
    end
  end

  describe 'validations' do
  end

  describe '#code' do
    let(:footnote) { build :footnote }

    it 'returns conjuction of footnote type id and footnote id' do
      footnote.code.should == [footnote.footnote_type_id, footnote.footnote_id].join
    end
  end
end
