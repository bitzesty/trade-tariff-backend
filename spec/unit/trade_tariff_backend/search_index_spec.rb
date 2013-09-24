require 'spec_helper'

describe TradeTariffBackend::SearchIndex do
  describe '.for' do
    context 'model include Tire Search module' do
      let(:tire_model) {
        Class.new do
          include Tire::Model::Search
        end
      }

      it 'returns instance of described class' do
        expect(described_class.for(tire_model.new)).to be_kind_of described_class
      end
    end

    context 'model does not include Tire Search module' do
      it 'returns nil' do
        expect(described_class.for(nil)).to eq nil
      end
    end
  end
end
