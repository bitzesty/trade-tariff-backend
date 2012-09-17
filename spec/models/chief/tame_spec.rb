require 'spec_helper'

describe Chief::Tame do
  let(:common_tame_attributes) { attributes_for(:tame).slice(:msrgp_code, :msr_type, :tty_code, :fe_tsmp) }

  describe 'associations' do
    describe 'tamfs' do
      let!(:tame) { create :tame, common_tame_attributes }
      let!(:tamf) { create :tamf, common_tame_attributes }

      context 'single choice' do
        it 'can be associated to one tamf record' do
          tame.tamfs.should include tamf
        end
      end

      context 'multiple choices' do
        let!(:tamf1) { create :tamf, common_tame_attributes.merge(fe_tsmp: Date.today.ago(20.years)) }

        it 'latest relevant tamf record is chosen' do
          tame.tamfs.should include tamf
          tame.tamfs.should include tamf1
        end
      end
    end
  end
end
