require 'rails_helper'

describe AdditionalCodeSearchService do
  describe 'additional code search' do
    around do |example|
      TimeMachine.now { example.run }
    end

    let!(:additional_code_1) { create :additional_code }
    let!(:additional_code_description_1) { create :additional_code_description, :with_period, additional_code_sid: additional_code_1.additional_code_sid }
    let!(:measure_1) { create :measure, additional_code_sid: additional_code_1.additional_code_sid }
    let!(:goods_nomenclature_1) { measure_1.goods_nomenclature }

    let!(:additional_code_2) { create :additional_code }
    let!(:additional_code_description_2) { create :additional_code_description, :with_period, additional_code_sid: additional_code_2.additional_code_sid }
    let!(:measure_2) { create :measure, additional_code_sid: additional_code_2.additional_code_sid }
    let!(:goods_nomenclature_2) { measure_2.goods_nomenclature }
    let(:current_page) { 1 }
    let(:per_page) { 20 }

    context 'by additional code' do
      it 'should find additional code by code' do
        result = described_class.new({
          'code' => additional_code_1.additional_code
        }, current_page, per_page).perform
        expect(result).to include(additional_code_1)
      end

      it 'should not find additional code by wrong code' do
        result = described_class.new({
          'code' => additional_code_1.additional_code
        }, current_page, per_page).perform
        expect(result).not_to include(additional_code_2)
      end
    end

    context 'by additional code type' do
      it 'should find additional code by type' do
        result = described_class.new({
          'type' => additional_code_1.additional_code_type_id
        }, current_page, per_page).perform
        expect(result).to include(additional_code_1)
      end

      it 'should not find additional code by wrong code' do
        result = described_class.new({
          'type' => additional_code_1.additional_code_type_id
        }, current_page, per_page).perform
        expect(result).not_to include(additional_code_2)
      end
    end

    context 'by description' do
      it 'should find additional code by description' do
        result = described_class.new({
          'description' => additional_code_1.description
        }, current_page, per_page).perform
        expect(result).to include(additional_code_1)
      end

      it 'should not find additional code by wrong description' do
        result = described_class.new({
          'description' => additional_code_1.description
        }, current_page, per_page).perform
        expect(result).not_to include(additional_code_2)
      end
    end

    context 'by description first word' do
      it 'should find additional code by description first word' do
        result = described_class.new({
          'description' => additional_code_1.description.split(' ').first
        }, current_page, per_page).perform
        expect(result).to include(additional_code_1)
      end

      it 'should not find additional code by wrong description first word' do
        result = described_class.new({
          'description' => additional_code_1.description.split(' ').first
        }, current_page, per_page).perform
        expect(result).not_to include(additional_code_2)
      end
    end
  end
end
