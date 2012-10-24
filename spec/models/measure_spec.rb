require 'spec_helper'

describe Measure do
  describe 'associations' do
    describe 'measure type' do
      let!(:measure)                { create :measure }
      let!(:measure_type1)   { create :measure_type, measure_type_id: measure.measure_type_id,
                                                     validity_start_date: 2.years.ago,
                                                     validity_end_date: nil }
      let!(:measure_type2) { create :measure_type, measure_type_id: measure.measure_type_id,
                                                   validity_start_date: 5.years.ago,
                                                   validity_end_date: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            measure.measure_type.pk.should == measure_type1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            measure.measure_type.pk.should == measure_type1.pk
          end

          TimeMachine.at(4.years.ago) do
            measure.reload.measure_type.pk.should == measure_type2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:measure_type)
                          .all
                          .first
                          .measure_type.pk.should == measure_type1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:measure_type)
                          .all
                          .first
                          .measure_type.pk.should == measure_type1.pk
          end

          TimeMachine.at(4.years.ago) do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:measure_type)
                          .all
                          .first
                          .measure_type.pk.should == measure_type2.pk
          end
        end
      end
    end

    describe 'measure conditions' do
      let!(:measure)                { create :measure }
      let!(:measure_condition1)     { create :measure_condition, measure_sid: measure.measure_sid }
      let!(:measure_condition2)     { create :measure_condition }

      context 'direct loading' do
        it 'loads associated measure conditions' do
          measure.measure_conditions.should include measure_condition1
        end

        it 'does not load associated measure condition' do
          measure.measure_conditions.should_not include measure_condition2
        end
      end

      context 'eager loading' do
        it 'loads associated measure conditions' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_conditions)
                 .all
                 .first
                 .measure_conditions.should include measure_condition1
        end

        it 'does not load associated measure condition' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_conditions)
                 .all
                 .first
                 .measure_conditions.should_not include measure_condition2
        end
      end
    end

    describe 'geographical area' do
      let!(:geographical_area1)     { create :geographical_area }
      let!(:geographical_area2)     { create :geographical_area }
      let!(:measure)                { create :measure, geographical_area_sid: geographical_area1.geographical_area_sid }

      context 'direct loading' do
        it 'loads associated measure conditions' do
          measure.geographical_area.should eq geographical_area1
        end

        it 'does not load associated measure condition' do
          measure.geographical_area.should_not eq geographical_area2
        end
      end

      context 'eager loading' do
        it 'loads associated measure conditions' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:geographical_area)
                 .all
                 .first
                 .geographical_area.should eq geographical_area1
        end

        it 'does not load associated measure condition' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:geographical_area)
                 .all
                 .first
                 .geographical_area.should_not eq geographical_area2
        end
      end
    end

    describe 'footnotes' do
      let!(:measure)          { create :measure }
      let!(:footnote1)        { create :footnote, validity_start_date: 2.years.ago,
                                                  validity_end_date: nil }
      let!(:footnote1_assoc)  { create :footnote_association_measure, measure_sid: measure.measure_sid,
                                                                      footnote_id: footnote1.footnote_id,
                                                                      footnote_type_id: footnote1.footnote_type_id }
      let!(:footnote2)        { create :footnote, validity_start_date: 5.years.ago,
                                                  validity_end_date: 3.years.ago }
      let!(:footnote2_assoc)  { create :footnote_association_measure, measure_sid: measure.measure_sid,
                                                                      footnote_id: footnote2.footnote_id,
                                                                      footnote_type_id: footnote2.footnote_type_id }

      context 'direct loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            measure.footnotes.map(&:pk).should include footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            measure.footnotes.map(&:pk).should include footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            measure.reload.footnotes.map(&:pk).should include footnote2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnotes.map(&:pk).should include footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnotes.map(&:pk).should include footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            Measure.where(measure_sid: measure.measure_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnotes.map(&:pk).should include footnote2.pk
          end
        end
      end
    end

    describe 'measure components' do
      let!(:measure)                { create :measure }
      let!(:measure_component1)     { create :measure_component, measure_sid: measure.measure_sid }
      let!(:measure_component2)     { create :measure_component }

      context 'direct loading' do
        it 'loads associated measure components' do
          measure.measure_components.should include measure_component1
        end

        it 'does not load associated measure component' do
          measure.measure_components.should_not include measure_component2
        end
      end

      context 'eager loading' do
        it 'loads associated measure components' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_components)
                 .all
                 .first
                 .measure_components.should include measure_component1
        end

        it 'does not load associated measure component' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_components)
                 .all
                 .first
                 .measure_components.should_not include measure_component2
        end
      end
    end

    describe 'additional code' do
      let!(:additional_code1)     { create :additional_code, validity_start_date: Date.today.ago(3.years) }
      let!(:additional_code2)     { create :additional_code, validity_start_date: Date.today.ago(5.years) }
      let!(:measure)              { create :measure, additional_code_sid: additional_code1.additional_code_sid }

      context 'direct loading' do
        it 'loads associated measure conditions' do
          measure.additional_code.should eq additional_code1
        end

        it 'does not load associated measure condition' do
          measure.additional_code.should_not eq additional_code2
        end
      end

      context 'eager loading' do
        it 'loads associated measure conditions' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:additional_code)
                 .all
                 .first
                 .additional_code.should eq additional_code1
        end

        it 'does not load associated measure condition' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:additional_code)
                 .all
                 .first
                 .additional_code.should_not eq additional_code2
        end
      end
    end

    describe 'quota order number' do
      let!(:quota_order_number1)     { create :quota_order_number, validity_start_date: Date.today.ago(3.years) }
      let!(:quota_order_number2)     { create :quota_order_number, validity_start_date: Date.today.ago(5.years) }
      let!(:measure)                 { create :measure, ordernumber: quota_order_number1.quota_order_number_id }

      context 'direct loading' do
        it 'loads associated measure conditions' do
          measure.quota_order_number.should eq quota_order_number1
        end

        it 'does not load associated measure condition' do
          measure.quota_order_number.should_not eq quota_order_number2
        end
      end

      context 'eager loading' do
        it 'loads associated measure conditions' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:quota_order_number)
                 .all
                 .first
                 .quota_order_number.should eq quota_order_number1
        end

        it 'does not load associated measure condition' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:quota_order_number)
                 .all
                 .first
                 .quota_order_number.should_not eq quota_order_number2
        end
      end
    end

    describe 'full temporary stop regulation' do
      let!(:fts_regulation1)        { create :fts_regulation, validity_start_date: Date.today.ago(3.years) }
      let!(:fts_regulation2)        { create :fts_regulation, validity_start_date: Date.today.ago(5.years) }
      let!(:fts_regulation_action1) { create :fts_regulation_action, fts_regulation_id: fts_regulation1.full_temporary_stop_regulation_id }
      let!(:fts_regulation_action2) { create :fts_regulation_action, fts_regulation_id: fts_regulation2.full_temporary_stop_regulation_id }
      let!(:measure)                { create :measure, measure_generating_regulation_id: fts_regulation_action1.stopped_regulation_id }

      context 'direct loading' do
        it 'loads associated full temporary stop regulation' do
          measure.full_temporary_stop_regulation.pk.should eq fts_regulation1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          measure.full_temporary_stop_regulation.pk.should_not eq fts_regulation2.pk
        end
      end

      context 'eager loading' do
        it 'loads associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:full_temporary_stop_regulation)
                 .all
                 .first
                 .full_temporary_stop_regulation.pk.should eq fts_regulation1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:full_temporary_stop_regulation)
                 .all
                 .first
                 .full_temporary_stop_regulation.pk.should_not eq fts_regulation2.pk
        end
      end
    end

    describe 'measure partial temporary stop' do
      let!(:mpt_stop1)        { create :measure_partial_temporary_stop, validity_start_date: Date.today.ago(3.years) }
      let!(:mpt_stop2)        { create :measure_partial_temporary_stop, validity_start_date: Date.today.ago(5.years) }
      let!(:measure)          { create :measure, measure_generating_regulation_id: mpt_stop1.partial_temporary_stop_regulation_id }

      context 'direct loading' do
        it 'loads associated full temporary stop regulation' do
          measure.measure_partial_temporary_stop.pk.should eq mpt_stop1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          measure.measure_partial_temporary_stop.pk.should_not eq mpt_stop2.pk
        end
      end

      context 'eager loading' do
        it 'loads associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_partial_temporary_stop)
                 .all
                 .first
                 .measure_partial_temporary_stop.pk.should eq mpt_stop1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_partial_temporary_stop)
                 .all
                 .first
                 .measure_partial_temporary_stop.pk.should_not eq mpt_stop2.pk
        end
      end
    end
  end

  describe 'validations' do
  end

  describe '#origin' do
    before(:all) { Measure.unrestrict_primary_key }

    it 'should be uk' do
      Measure.new(measure_sid: -1).origin.should == "uk"
    end
    it 'should be eu' do
      Measure.new(measure_sid: 1).origin.should == "eu"
    end
  end

  describe "#measure_generating_regulation_id" do
    it 'reads measure generating regulation id from database' do
      measure = create :measure
      measure.measure_generating_regulation_id.should_not be_blank
      measure.measure_generating_regulation_id.should == Measure.first.measure_generating_regulation_id
    end

    it 'measure D9500019 is globally replaced with D9601421' do
      measure = create :measure, measure_generating_regulation_id: "D9500019"
      measure.measure_generating_regulation_id.should_not be_blank
      measure.measure_generating_regulation_id.should == "D9601421"
    end
  end
end
