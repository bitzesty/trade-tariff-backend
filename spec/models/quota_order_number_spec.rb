require 'rails_helper'

RSpec.describe QuotaOrderNumber do
  context 'with an existing QuotaOrderNumber' do
    let(:quota_order_number) { create(:quota_order_number) }
    let(:definition) { create(:quota_definition, quota_order_number_id: quota_order_number.quota_order_number_id) }

    before { definition }

    describe '#quota_definition!' do
      subject { quota_order_number.quota_definition! }

      it { is_expected.to eq(definition) }
    end
  end

  context 'without a persisted QuotaOrderNumber' do
    context 'when not handled by the RPA' do
      let(:quota_order_number) { described_class.new(quota_order_number_id: '090000') }

      describe '#quota_definition!' do
        it 'raises an error due to missing primary key' do
          expect { quota_order_number.quota_definition! }.to raise_error(Sequel::Error)
        end
      end
    end

    context 'when handled by the RPA' do
      let(:quota_order_number) { described_class.new(quota_order_number_id: '094504') }

      describe '#quota_definition!' do
        it 'returns nil' do
          expect(quota_order_number.quota_definition!).to eq(nil)
        end
      end
    end
  end
end
