require 'rails_helper'

describe QuotaSearchService do

  describe 'quota search' do
    around do |example|
      TimeMachine.now { example.run }
    end

    let(:validity_start_date) { Date.new(Date.current.year, 1, 1) }
    let(:quota_order_number1) { create :quota_order_number }
    let!(:measure1) { create :measure, ordernumber: quota_order_number1.quota_order_number_id, validity_start_date: validity_start_date }
    let!(:quota_definition1) {
      create :quota_definition,
             quota_order_number_sid: quota_order_number1.quota_order_number_sid,
             quota_order_number_id: quota_order_number1.quota_order_number_id,
             critical_state: 'Y',
             validity_start_date: validity_start_date
    }
    let!(:quota_order_number_origin1) {
      create :quota_order_number_origin,
             :with_geographical_area,
             quota_order_number_sid: quota_order_number1.quota_order_number_sid
    }

    let(:quota_order_number2) { create :quota_order_number }
    let!(:measure2) { create :measure, ordernumber: quota_order_number2.quota_order_number_id, validity_start_date: validity_start_date }
    let!(:quota_definition2) {
      create :quota_definition,
             quota_order_number_sid: quota_order_number2.quota_order_number_sid,
             quota_order_number_id: quota_order_number2.quota_order_number_id,
             critical_state: 'N',
             validity_start_date: validity_start_date
    }
    let!(:quota_order_number_origin2) {
      create :quota_order_number_origin,
             :with_geographical_area,
             quota_order_number_sid: quota_order_number2.quota_order_number_sid
    }

    before do
      measure1.update(geographical_area_id: quota_order_number_origin1.geographical_area_id)
      measure2.update(geographical_area_id: quota_order_number_origin2.geographical_area_id)
    end

    context 'by goods_nomenclature_item_id' do
      it 'should find quota definition by goods nomenclature' do
        result = described_class.new(
          {
            'goods_nomenclature_item_id' => measure1.goods_nomenclature_item_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).to include(quota_definition1)
      end
      it 'should not find quota definition by wrong goods nomenclature' do
        result = described_class.new(
          {
            'goods_nomenclature_item_id' => measure1.goods_nomenclature_item_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).not_to include(quota_definition2)
      end
    end

    context 'by geographical_area_id' do
      it 'should find quota definition by geographical area' do
        result = described_class.new(
          {
            'geographical_area_id' => quota_order_number_origin1.geographical_area_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).to include(quota_definition1)
      end
      it 'should not find quota definition by wrong geographical area' do
        result = described_class.new(
          {
            'geographical_area_id' => quota_order_number_origin1.geographical_area_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).not_to include(quota_definition2)
      end
    end

    context 'by order_number' do
      it 'should find quota definition by order number' do
        result = described_class.new(
          {
            'order_number' => quota_order_number1.quota_order_number_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).to include(quota_definition1)
      end
      it 'should not find quota definition by wrong order number' do
        result = described_class.new(
          {
            'order_number' => quota_order_number1.quota_order_number_id,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).not_to include(quota_definition2)
      end
    end

    context 'by critical' do
      it 'should find quota definition by critical state' do
        result = described_class.new(
          {
            'critical' => quota_definition1.critical_state,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).to include(quota_definition1)
      end
      it 'should not find quota definition by wrong critical state' do
        result = described_class.new(
          {
            'critical' => quota_definition1.critical_state,
            'year' => Date.current.year.to_s
          }).perform
        expect(result).not_to include(quota_definition2)
      end
    end

    context 'by year' do
      let(:past_validity_start_date) { Date.new(Date.current.year - 1, 1, 1) }
      let(:quota_order_number3) { create :quota_order_number }
      let!(:measure3) { create :measure, ordernumber: quota_order_number3.quota_order_number_id, validity_start_date: past_validity_start_date }
      let!(:quota_definition3) {
        create :quota_definition,
               quota_order_number_sid: quota_order_number3.quota_order_number_sid,
               quota_order_number_id: quota_order_number3.quota_order_number_id,
               critical_state: 'N',
               validity_start_date: past_validity_start_date
      }
      let!(:quota_order_number_origin3) {
        create :quota_order_number_origin,
               :with_geographical_area,
               quota_order_number_sid: quota_order_number3.quota_order_number_sid
      }

      it 'should find quota definition by year' do
        result = described_class.new(
          {
            'year' => Date.current.year.to_s
          }).perform
        expect(result).to include(quota_definition1)
      end
      it 'should find quota definition by multiple years' do
        result = described_class.new(
          {
            'year' => [Date.current.year.to_s, (Date.current.year - 1).to_s]
          }).perform
        expect(result).to include(quota_definition1)
        expect(result).to include(quota_definition3)
      end
      it 'should not find quota definition by wrong year' do
        result = described_class.new(
          {
            'year' => Date.current.year.to_s
          }).perform
        expect(result).not_to include(quota_definition3)
      end
    end

    context 'by status' do
      context 'exhausted' do
        let!(:quota_exhaustion_event) {
          create :quota_exhaustion_event,
                 quota_definition: quota_definition1
        }
        it 'should find quota definition by exhausted status' do
          result = described_class.new(
            {
              'status' => 'Exhausted',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).to include(quota_definition1)
        end
        it 'should not find quota definition by wrong exhausted status' do
          result = described_class.new(
            {
              'status' => 'Exhausted',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).not_to include(quota_definition2)
        end
      end

      context 'not exhausted' do
        let!(:quota_exhaustion_event) {
          create :quota_exhaustion_event,
                 quota_definition: quota_definition1
        }
        it 'should find quota definition by not exhausted status' do
          result = described_class.new(
            {
              'status' => 'Not exhausted',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).to include(quota_definition2)
        end
        it 'should not find quota definition by wrong not exhausted status' do
          result = described_class.new(
            {
              'status' => 'Not exhausted',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).not_to include(quota_definition1)
        end
      end

      context 'blocked' do
        let!(:quota_blocking_period) {
          create :quota_blocking_period,
                 quota_definition_sid: quota_definition1.quota_definition_sid,
                 blocking_start_date: Date.current,
                 blocking_end_date: 1.year.from_now
        }
        it 'should find quota definition by blocked status' do
          result = described_class.new(
            {
              'status' => 'Blocked',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).to include(quota_definition1)
        end
        it 'should not find quota definition by wrong blocked status' do
          result = described_class.new(
            {
              'status' => 'Blocked',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).not_to include(quota_definition2)
        end
      end

      context 'not blocked' do
        let!(:quota_blocking_period) {
          create :quota_blocking_period,
                 quota_definition_sid: quota_definition1.quota_definition_sid,
                 blocking_start_date: Date.current,
                 blocking_end_date: 1.year.from_now
        }
        it 'should find quota definition by not blocked status' do
          result = described_class.new(
            {
              'status' => 'Not blocked',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).to include(quota_definition2)
        end
        it 'should not find quota definition by wrong not blocked status' do
          result = described_class.new(
            {
              'status' => 'Not blocked',
              'year' => Date.current.year.to_s
            }).perform
          expect(result).not_to include(quota_definition1)
        end
      end
    end
  end
end