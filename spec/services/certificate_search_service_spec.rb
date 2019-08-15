require 'rails_helper'

describe CertificateSearchService do
  describe 'certificate search' do
    around do |example|
      TimeMachine.now { example.run }
    end

    let!(:certificate_1) { create :certificate }
    let!(:certificate_description_1) {
      create :certificate_description,
        :with_period,
        certificate_type_code: certificate_1.certificate_type_code,
        certificate_code: certificate_1.certificate_code
    }
    let!(:measure_1) { create :measure }
    let!(:goods_nomenclature_1) { measure_1.goods_nomenclature }
    let!(:measure_condition_1) { 
      create :measure_condition,
        certificate_type_code: certificate_1.certificate_type_code,
        certificate_code: certificate_1.certificate_code,
        measure_sid: measure_1.measure_sid
    }
    
    let!(:certificate_2) { create :certificate }
    let!(:certificate_description_2) {
      create :certificate_description,
        :with_period,
        certificate_type_code: certificate_2.certificate_type_code,
        certificate_code: certificate_2.certificate_code
    }
    let!(:measure_2) { create :measure }
    let!(:goods_nomenclature_2) { measure_2.goods_nomenclature }
    let!(:measure_condition_2) { 
      create :measure_condition,
        certificate_type_code: certificate_2.certificate_type_code,
        certificate_code: certificate_2.certificate_code,
        measure_sid: measure_2.measure_sid
    }
    
    context 'by certificate code' do
      it 'should find certificate by code' do
        result = described_class.new({
          'code' => certificate_1.certificate_code
        }).perform
        expect(result).to include(certificate_1)
      end

      it 'should not find additional code by wrong code' do
        result = described_class.new({
          'code' => certificate_1.certificate_code
        }).perform
        expect(result).not_to include(certificate_2)
      end
    end

    context 'by description' do
      it 'should find certificate by description' do
        result = described_class.new({
          'description' => certificate_1.description
        }).perform
        expect(result).to include(certificate_1)
      end

      it 'should not find certificate by wrong description' do
        result = described_class.new({
          'description' => certificate_1.description
        }).perform
        expect(result).not_to include(certificate_2)
      end
    end

    context 'by description first word' do
      it 'should find certificate by description first word' do
        result = described_class.new({
          'description' => certificate_1.description.split(' ').first
        }).perform
        expect(result).to include(certificate_1)
      end

      it 'should not find certificate by wrong description first word' do
        result = described_class.new({
          'description' => certificate_1.description.split(' ').first
        }).perform
        expect(result).not_to include(certificate_2)
      end
    end
  end
end
