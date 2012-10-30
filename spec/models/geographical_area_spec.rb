require 'spec_helper'

describe GeographicalArea do
  describe 'associations' do
    describe 'geographical area description' do
      let!(:geographical_area)                { create :geographical_area }
      let!(:geographical_area_description1)   { create :geographical_area_description, :with_period,
                                                            geographical_area_sid: geographical_area.geographical_area_sid,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil }
      let!(:geographical_area_description2) { create :geographical_area_description, :with_period,
                                                            geographical_area_sid: geographical_area.geographical_area_sid,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            geographical_area.geographical_area_description.pk.should == geographical_area_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            geographical_area.geographical_area_description.pk.should == geographical_area_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            geographical_area.reload.geographical_area_description.pk.should == geographical_area_description2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:geographical_area_description)
                          .all
                          .first
                          .geographical_area_description.pk.should == geographical_area_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:geographical_area_description)
                          .all
                          .first
                          .geographical_area_description.pk.should == geographical_area_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:geographical_area_description)
                          .all
                          .first
                          .geographical_area_description.pk.should == geographical_area_description2.pk
          end
        end
      end
    end

    describe 'contained geographical areas' do
      let!(:geographical_area)                { create :geographical_area }
      let!(:contained_area_present)           { create :geographical_area, validity_start_date: Date.today.ago(2.years),
                                                                           validity_end_date: Date.today.ago(2.years) }
      let!(:contained_area_past)              { create :geographical_area, validity_start_date: Date.today.ago(5.years),
                                                                           validity_end_date: Date.today.ago(3.years) }
      let!(:geographical_area_membership1)    { create :geographical_area_membership, geographical_area_sid: contained_area_present.geographical_area_sid,
                                                                                      geographical_area_group_sid: geographical_area.geographical_area_sid,
                                                                                      validity_start_date: Date.today.ago(2.years),
                                                                                      validity_end_date: nil }
      let!(:geographical_area_membership2)    { create :geographical_area_membership, geographical_area_sid: contained_area_past.geographical_area_sid,
                                                                                      geographical_area_group_sid: geographical_area.geographical_area_sid,
                                                                                      validity_start_date: Date.today.ago(5.years),
                                                                                      validity_end_date: Date.today.ago(3.years) }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            geographical_area.contained_geographical_areas.map(&:pk).should include contained_area_present.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            geographical_area.contained_geographical_areas.map(&:pk).should include contained_area_present.pk
          end

          TimeMachine.at(4.years.ago) do
            geographical_area.reload.contained_geographical_areas.map(&:pk).should include contained_area_past.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas
                          .map(&:pk).should include contained_area_present.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas
                          .map(&:pk).should include contained_area_present.pk
          end

          TimeMachine.at(4.years.ago) do
            GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas
                          .map(&:pk).should include contained_area_past.pk
          end
        end
      end
    end
  end

  describe 'validations' do
    # GA1 The combination geographical area id + validity start date must be unique.
    it { should validate_uniqueness.of([:geographical_area_id, :validity_start_date])}
    # GA2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
  end

  describe '#iso_code' do
    let(:geographical_area)                { build :geographical_area, geographical_area_id: 'UK' }

    it 'is an alias to geographical area id' do
      geographical_area.iso_code.should == 'UK'
    end
  end
end
