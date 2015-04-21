require 'rails_helper'

describe Chief::Mfcm do
  let(:common_mfcm_attributes) { attributes_for(:mfcm).slice(:msrgp_code, :msr_type, :tty_code, :fe_tsmp) }

  describe 'associations' do
    describe 'tame' do
      let!(:mfcm) { create :mfcm, common_mfcm_attributes }
      let!(:tame) { create :tame, common_mfcm_attributes }

      context 'single choice' do
        it 'can be associated to one tame record' do
          expect(mfcm.tame).to eq tame
        end
      end

      context 'multiple choices' do
        let!(:tame1) { create :tame, common_mfcm_attributes.merge(fe_tsmp: Date.today.ago(20.years)) }

        it 'latest relevant tame record is chosen' do
          expect(mfcm.tame).to     eq tame
          expect(mfcm.tame).to_not eq tame1
        end
      end
    end
  end

  describe '#mark_as_processed!' do
    let!(:mfcm) { create :mfcm }

    it 'marks itself as processed' do
      expect(mfcm.processed).to be_falsy
      mfcm.mark_as_processed!
      expect(mfcm.reload.processed).to be_truthy
    end
  end
end
