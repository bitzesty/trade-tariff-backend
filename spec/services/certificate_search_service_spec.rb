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
    let(:current_page) { 1 }
    let(:per_page) { 20 }

    before do
      Sidekiq::Testing.inline! do
        TradeTariffBackend.cache_client.reindex
        sleep(1)
      end
    end

    context 'by certificate code' do
      it 'should find certificate by code' do
        result = described_class.new({
          'code' => certificate_1.certificate_code
        }, current_page, per_page).perform
        expect(result.map(&:id)).to include(certificate_1.id)
      end

      it 'should not find additional code by wrong code' do
        result = described_class.new({
          'code' => certificate_1.certificate_code
        }, current_page, per_page).perform
        expect(result.map(&:id)).not_to include(certificate_2.id)
      end
    end

    context 'by certificate type' do
      it 'should find certificate by type' do
        result = described_class.new({
          'type' => certificate_1.certificate_type_code
        }, current_page, per_page).perform
        expect(result.map(&:id)).to include(certificate_1.id)
      end

      it 'should not find additional code by wrong type' do
        result = described_class.new({
          'type' => certificate_1.certificate_type_code
        }, current_page, per_page).perform
        expect(result.map(&:id)).not_to include(certificate_2.id)
      end
    end

    context 'by description' do
      it 'should find certificate by description' do
        result = described_class.new({
          'description' => certificate_1.description
        }, current_page, per_page).perform
        expect(result.map(&:id)).to include(certificate_1.id)
      end

      it 'should not find certificate by wrong description' do
        result = described_class.new({
          'description' => certificate_1.description
        }, current_page, per_page).perform
        expect(result.map(&:id)).not_to include(certificate_2.id)
      end
    end

    context 'by description first word' do
      it 'should find certificate by description first word' do
        result = described_class.new({
          'description' => certificate_1.description.split(' ').first
        }, current_page, per_page).perform
        expect(result.map(&:id)).to include(certificate_1.id)
      end

      it 'should not find certificate by wrong description first word' do
        result = described_class.new({
          'description' => certificate_1.description.split(' ').first
        }, current_page, per_page).perform
        expect(result.map(&:id)).not_to include(certificate_2.id)
      end
    end
  end
end
