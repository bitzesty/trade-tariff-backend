require 'spec_helper'

describe Chief::Mfcm do
  let(:common_mfcm_attributes) { attributes_for(:mfcm).slice(:msrgp_code, :msr_type, :tty_code, :fe_tsmp) }

  describe 'associations' do
    describe 'tame' do
      let!(:mfcm) { create :mfcm, common_mfcm_attributes }
      let!(:tame) { create :tame, common_mfcm_attributes }

      context 'single choice' do
        it 'can be associated to one tame record' do
          mfcm.tame.should == tame
        end
      end

      context 'multiple choices' do
        let!(:tame1) { create :tame, common_mfcm_attributes.merge(fe_tsmp: Date.today.ago(20.years)) }

        it 'latest relevant tame record is chosen' do
          mfcm.tame.should     == tame
          mfcm.tame.should_not == tame1
        end
      end
    end
  end

  describe '#mark_as_processed!' do
    let!(:mfcm) { create :mfcm }

    it 'marks itself as processed' do
      mfcm.processed.should be_false
      mfcm.mark_as_processed!
      mfcm.reload.processed.should be_true
    end
  end
end
