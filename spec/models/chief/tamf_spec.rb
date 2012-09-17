require 'spec_helper'

describe Chief::Tamf do
  describe 'associations' do
    describe 'measure_type_conds' do
      let!(:common) { attributes_for(:measure_type_cond) }
      let!(:tamf)   { create :tamf, msrgp_code: common[:measure_group_code], msr_type: common[:measure_type] }
      let!(:measure_type_cond)  { create :measure_type_cond, common }
      let!(:measure_type_cond_irrelevant) { create :measure_type_cond }

      it 'associates correct Chief measure type conditions' do
        tamf.measure_type_conds.should     include measure_type_cond
        tamf.measure_type_conds.should_not include measure_type_cond_irrelevant
      end
    end
  end
end
