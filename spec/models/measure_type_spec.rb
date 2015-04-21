require 'rails_helper'

describe MeasureType do
  describe 'validations' do
    # MT1 The measure type code must be unique.
    it { should validate_uniqueness.of :measure_type_id }
    # MT2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
    # MT4 The referenced measure type series must exist.
    it { should validate_presence.of(:measure_type_series) }
  end

  describe '#excise?' do
    let(:measure_type) { build :measure_type, measure_type_id: measure_type_description.measure_type_id, measure_type_description: measure_type_description }

    context 'measure type is Excise related' do
      let!(:measure_type_description) { create :measure_type_description, description: 'EXCISE 111' }

      it 'returns true' do
        expect(measure_type).to be_excise
      end
    end

    context 'measure type is not Excise related' do
      let(:measure_type_description) { create :measure_type_description, description: 'not really e_x_c_i_s_e' }

      it 'returns false' do
        expect(measure_type).not_to be_excise
      end
    end
  end

  describe '#third_country?' do
    context 'measure_type is third country' do
      let(:measure_type) { build :measure_type, measure_type_id: MeasureType::THIRD_COUNTRY }

      it 'returns true' do
        expect(measure_type).to be_third_country
      end
    end

    context 'measure_type is not third country' do
      let(:measure_type) { build :measure_type, measure_type_id: 'aaa' }

      it 'returns false' do
        expect(measure_type).not_to be_third_country
      end
    end
  end
end
