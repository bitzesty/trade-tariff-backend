require 'spec_helper'

describe Measure do
  describe '#generating_regulation' do
    let(:measure_of_base_regulation) { create :measure }
    let(:measure_of_modification_regulation) { create :measure, :with_modification_regulation }

    it 'returns relevant regulation that is generating the measure' do
      measure_of_base_regulation.generating_regulation.should eq measure_of_base_regulation.base_regulation
      measure_of_modification_regulation.generating_regulation.should eq measure_of_modification_regulation.modification_regulation
    end
  end

  # According to Taric guide
  describe '#validity_end_date' do
    let(:base_regulation) { create :base_regulation, effective_end_date: Date.yesterday }
    let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                     base_regulation: base_regulation,
                                     validity_end_date: Date.today }

    context 'measure end date greater than generating regulation end date' do
      it 'returns validity end date of' do
        measure.validity_end_date.to_date.should eq base_regulation.effective_end_date.to_date
      end
    end

    context 'measure end date lesser than generating regulation end date' do
      let(:base_regulation) { create :base_regulation, effective_end_date: Date.today }
      let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                       base_regulation: base_regulation,
                                       validity_end_date: Date.yesterday }

      it 'returns validity end date of the measure' do
        measure.validity_end_date.to_date.should eq measure.validity_end_date.to_date
      end
    end

    context 'generating regulation effective end date blank, measure end date blank' do
      let(:base_regulation) { create :base_regulation, effective_end_date: nil }
      let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                       base_regulation: base_regulation,
                                       validity_end_date: nil }

      it 'returns validity end date of the measure' do
        measure.validity_end_date.should be_blank
      end
    end

    context 'generating regulation effective end date blank, measure end date present' do
      let(:base_regulation) { create :base_regulation, effective_end_date: nil }
      let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                       base_regulation: base_regulation,
                                       validity_end_date: Date.today }

      it 'returns validity end date of the measure' do
        measure.validity_end_date.should be_blank
      end
    end

    context 'generating regulation effective end date present, measure end date blank' do
      let(:base_regulation) { create :base_regulation, effective_end_date: Date.today}
      let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                       base_regulation: base_regulation,
                                       validity_end_date: nil }

      it 'returns validity end date of the measure' do
        measure.validity_end_date.to_date.should eq Date.today
      end
    end

    context 'measure is national' do
      let(:base_regulation) { create :base_regulation, effective_end_date: Date.yesterday }
      let(:measure) { create :measure, measure_generating_regulation_role: 1,
                                       base_regulation: base_regulation,
                                       validity_end_date: Date.today,
                                       national:true }

      it 'returns validity end date of the measure' do
        measure.validity_end_date.to_date.should eq Date.today
      end
    end
  end

  describe 'associations' do
    describe 'measure type' do
      let!(:measure)         { create :measure }
      let!(:measure_type1)   { create :measure_type, measure_type_id: measure.measure_type_id,
                                                     validity_start_date: 5.years.ago,
                                                     validity_end_date: 3.years.ago,
                                                     operation_date: Date.yesterday }
      let!(:measure_type2)   { create :measure_type, measure_type_id: measure.measure_type_id,
                                                     validity_start_date: 2.years.ago,
                                                     validity_end_date: nil,
                                                     operation: :update }

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

      describe 'ordering' do
        let!(:measure)                { create :measure }
        let!(:measure_condition1)     { create :measure_condition, measure_sid: measure.measure_sid, component_sequence_number: 10 }
        let!(:measure_condition2)     { create :measure_condition, measure_sid: measure.measure_sid, component_sequence_number: 1 }

        it 'loads conditions ordered by component sequence number ascending' do
          expect(measure.measure_conditions.first).to eq measure_condition2
          expect(measure.measure_conditions.last).to eq measure_condition1
        end
      end
    end

    describe 'geographical area' do
      let!(:geographical_area1)     { create :geographical_area, geographical_area_id: 'ab' }
      let!(:geographical_area2)     { create :geographical_area, geographical_area_id: 'de' }
      let!(:measure)                { create :measure, geographical_area_sid: geographical_area1.geographical_area_sid }

      context 'direct loading' do
        it 'loads associated measure conditions' do
          measure.geographical_area.pk.should eq geographical_area1.pk
        end

        it 'does not load associated measure condition' do
          measure.geographical_area.pk.should_not eq geographical_area2.pk
        end
      end

      context 'eager loading' do
        it 'loads associated measure conditions' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:geographical_area)
                 .all
                 .first
                 .geographical_area.pk.should eq geographical_area1.pk
        end

        it 'does not load associated measure condition' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:geographical_area)
                 .all
                 .first
                 .geographical_area.pk.should_not eq geographical_area2.pk
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
                 .eager(:full_temporary_stop_regulations)
                 .all
                 .first
                 .full_temporary_stop_regulation.pk.should eq fts_regulation1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:full_temporary_stop_regulations)
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
                 .eager(:measure_partial_temporary_stops)
                 .all
                 .first
                 .measure_partial_temporary_stop.pk.should eq mpt_stop1.pk
        end

        it 'does not load associated full temporary stop regulation' do
          Measure.where(measure_sid: measure.measure_sid)
                 .eager(:measure_partial_temporary_stops)
                 .all
                 .first
                 .measure_partial_temporary_stop.pk.should_not eq mpt_stop2.pk
        end
      end
    end
  end

  describe 'validations' do
    # ME2 ME4 ME6 ME24 The <field name> must exist.
    it { should validate_presence.of(:measure_type) }
    # ME4
    it { should validate_presence.of(:geographical_area) }
    # ME6
    it { should validate_presence.of(:goods_nomenclature) }
    # ME24
    it { should validate_presence.of(:measure_generating_role_id) }
    it { should validate_presence.of(:measure_generating_role_type) }
    # ME1 The combination of measure type + geographical area +
    #     goods nomenclature item id + additional code type + additional code +
    #     order number + reduction indicator + start date must be unique
    it { should validate_uniqueness.of([:measure_type_id,
                                        :geographical_area_sid,
                                        :goods_nomenclature_sid,
                                        :export_refund_nomenclature_sid,
                                        :additional_code_type_id,
                                        :additional_code_id, :ordernumber,
                                        :reduction_indicator,
                                        :validity_start_date]) }
    # ME4 ME5
    it { should validate_validity_date_span.of(:geographical_area) }
    # ME2 ME3
    it { should validate_validity_date_span.of(:measure_type) }
    # ME6 ME8
    it { should validate_validity_date_span.of(:goods_nomenclature) }
    # ME25 If the measures end date is specified (implicitly or explicitly)
    # then the start date of the measure must be less than
    # or equal to the end date
    it { should validate_validity_dates }

    describe 'ME7' do
      let(:measure1) { create :measure, gono_producline_suffix: "80" }
      let(:measure2) { create :measure, gono_producline_suffix: "20" }

      it 'performs validation' do
        measure1.should be_conformant
        measure2.should_not be_conformant
      end
    end

    describe 'ME9' do
      context 'additional_code blank, goods nomenclature code blank' do
        let(:measure) { create :measure, additional_code_id: nil,
                                         goods_nomenclature_item_id: nil }

        it 'performs validation' do
          measure.should_not be_conformant
        end
      end

      context 'additional_code present' do
        let(:measure) { create :measure, additional_code_id: '123' }

        it 'performs validation' do
          measure.should be_conformant
        end
      end
    end

    describe 'ME10' do
      let(:measure1) { create :measure, :with_quota_order_number, order_number_capture_code: 1, ordernumber: nil }
      let(:measure2) { create :measure, :with_quota_order_number, order_number_capture_code: 2, ordernumber: '123' }
      let(:measure3) { create :measure, :with_quota_order_number, order_number_capture_code: 1, ordernumber: '123' }

      it 'performs validation' do
        measure1.should_not be_conformant
        measure2.should_not be_conformant
        measure3.should     be_conformant
      end
    end

    describe 'ME12' do
      let(:measure1) { create :measure, :with_additional_code_type }
      let(:measure2) { create :measure, :with_related_additional_code_type }

      it 'performs validation' do
        measure1.should_not be_conformant
        measure2.should be_conformant
      end
    end

    describe 'ME13' do
      context 'additional code type meursing and attributes missing' do
        let(:measure) { create :measure, :with_related_additional_code_type,
                                        additional_code_type_id: 3,
                                        additional_code_id: '123',
                                        goods_nomenclature_item_id: nil,
                                        ordernumber: nil,
                                        reduction_indicator: nil }

        it 'should be valid' do
          measure.should be_conformant
        end
      end

      context 'additional code type meursing and attributes present' do
        let(:measure) { create :measure, :with_related_additional_code_type,
                                         :with_quota_order_number,
                                        additional_code_type_id: 3,
                                        additional_code_id: '123',
                                        goods_nomenclature_item_id: '1234567890',
                                        ordernumber: '12345',
                                        reduction_indicator: 1 }

        it 'should no be valid' do
          measure.should_not be_conformant
        end
      end

      context 'additional code type non meursing' do
        let(:measure) { create :measure, :with_related_additional_code_type,
                                        additional_code_type_id: 3 }

        it 'should be valid' do
          measure.should be_conformant
        end
      end
    end

    describe 'ME14' do
      context 'additional code type meursing, additional code is associated to export refund nomenclature' do
        let(:additional_code) { create :additional_code, :with_export_refund_nomenclature }
        let(:measure) { create :measure, :with_related_additional_code_type,
                                         :with_quota_order_number,
                                        additional_code_type_id: 3,
                                        additional_code_id: additional_code.additional_code,
                                        goods_nomenclature_item_id: '1234567890',
                                        ordernumber: '12345',
                                        reduction_indicator: 1,
                                        order_number_capture_code: 1 }

        it 'should be valid' do
          measure.should be_conformant
        end
      end

      context 'additional code type meursing, additional code is not associated to export refund nomenclature' do
        let(:additional_code) { create :additional_code }
        let(:measure) { create :measure, :with_related_additional_code_type,
                                         :with_quota_order_number,
                                        additional_code_type_id: 3,
                                        additional_code_id: additional_code.additional_code,
                                        goods_nomenclature_item_id: '1234567890',
                                        ordernumber: '12345',
                                        reduction_indicator: 1 }

        it 'should not be valid' do
          measure.should_not be_conformant
        end
      end

      context 'additional code type non meursing' do
        let(:measure) { create :measure, :with_related_additional_code_type,
                                        additional_code_type_id: 3 }

        it 'should be valid' do
          measure.should be_conformant
        end
      end
    end

    describe 'ME26' do
      it { should validate_exclusion.of([:measure_generating_regulation_id, :measure_generating_regulation_role])
                                    .from(->{ CompleteAbrogationRegulation.select(:complete_abrogation_regulation_id, :complete_abrogation_regulation_role) }) }
    end

    describe 'ME27' do
      let(:measure) { create :measure }

      context 'regulation fully replaced' do
        before { measure.generating_regulation.update(replacement_indicator: 1)}

        it 'should not be valid' do
          measure.conformant?.should be_false
        end
      end

      context 'regulation partially replaced' do
        before { measure.generating_regulation.update(replacement_indicator: 2)}

        it 'should be valid' do
          measure.conformant?.should be_true
        end
      end

      context 'regulation not replaced' do
        before { measure.generating_regulation.update(replacement_indicator: 0)}

        it 'should be valid' do
          measure.conformant?.should be_true
        end
      end
    end

    describe 'ME33' do
      let(:measure) { create :measure, justification_regulation_id: nil,
                                      justification_regulation_role: nil }

      context 'measure validity end date is set' do
        before { measure.validity_end_date = Date.today }

        it 'performs validation' do
          measure.should_not be_conformant
        end
      end

      context 'measure validity end date is not set' do
        before { measure.validity_end_date = nil }

        it 'performs validation' do
          measure.should be_conformant
        end
      end
    end

    describe 'ME29' do
      context 'generating modification regulation abrogated' do
        let(:measure) { create :measure, :with_abrogated_modification_regulation }

        it 'performs validation' do
          measure.should_not be_conformant
        end
      end

      context 'generating regulation is not modification regulation' do
        let(:measure) { create :measure }

        it 'performs validation' do
          measure.should be_conformant
        end
      end
    end

    describe 'ME34' do
      let(:measure) { create :measure, justification_regulation_id: 'abc',
                                      justification_regulation_role: 1 }

      context 'measure validity end date is set' do
        before {
          measure.geographical_area.update(validity_end_date: Date.today.in(1.year))
          measure.measure_type.update(validity_end_date: Date.today.in(1.year))
          measure.goods_nomenclature.update(validity_end_date: Date.today.in(1.year))

          measure.validity_end_date = Date.today
        }

        it 'performs validation' do
          measure.should be_conformant
        end
      end

      context 'measure validity end date is not set' do
        before { measure.validity_end_date = nil }

        it 'performs validation' do
          measure.should_not be_conformant
        end
      end
    end

    describe 'ME86' do
      it { should validate_inclusion.of(:measure_generating_regulation_role).in(Measure::VALID_ROLE_TYPE_IDS) }
    end

    describe 'ME88' do
      let(:measure1) { create :measure, type_explosion_level: 10,
                                        gono_number_indents: 1 }
      let(:measure2) { create :measure, type_explosion_level: 1,
                                        gono_number_indents: 10 }

      it 'preforms validation' do
        measure1.should be_conformant
        measure2.should_not be_conformant
      end
    end

    describe 'ME116' do
      it { should validate_validity_date_span.of(:order_number) }
    end
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

  describe "#order_number" do
    context "quota_order_number associated" do
      let(:quota_order_number) { create :quota_order_number }
      let(:measure) { create :measure, ordernumber: quota_order_number.quota_order_number_id }

      it 'should return associated quota order nmber' do
        measure.order_number.should eq quota_order_number
      end
    end

    context "quota_order_number missing" do
      let(:ordernumber) { 6.times.map{ Random.rand(9) }.join }
      let(:measure) { create :measure, ordernumber: ordernumber }

      it 'should return a mock quota order number with just the number set' do
        measure.order_number.quota_order_number_id.should eq ordernumber
      end

      it 'associated mock quota order number should have no quota definition' do
        measure.order_number.quota_definition.should be_blank
      end
    end
  end

  describe "#import" do
    let(:measure) { create :measure, measure_type: measure_type }

    context 'measure type is import' do
      let(:measure_type) { create :measure_type, :import }

      it 'returns true' do
        expect(measure.import).to be_true
      end
    end

    context 'measure type is export' do
      let(:measure_type) { create :measure_type, :export }

      it 'returns false' do
        expect(measure.import).to be_false
      end
    end
  end

  describe "#export" do
    let(:measure) { create :measure, measure_type: measure_type }

    context 'measure type is import' do
      let(:measure_type) { create :measure_type, :import }

      it 'returns false' do
        expect(measure.export).to be_false
      end
    end

    context 'measure type is export' do
      let(:measure_type) { create :measure_type, :export }

      it 'returns true' do
        expect(measure.export).to be_true
      end
    end
  end
end
