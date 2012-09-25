require 'spec_helper'
require 'chief_transformer'

describe ChiefTransformer::CandidateMeasure::Collection do
  describe '#persist' do
    context 'just MFCM present' do
      let!(:mfcm) { create :mfcm }

      it 'creates no measures' do
        ChiefTransformer.instance.invoke(:initial_load)
        Measure.count.should == 0
      end

      it 'creates no measure associations' do
        ChiefTransformer.instance.invoke(:initial_load)
        MeasureComponent.count.should == 0
      end
    end

    context 'MFCM & TAME present' do
      let!(:mfcm) { create :mfcm, :with_tame_components,
                                  :with_vat_group,
                                  :with_geographical_area,
                                  :with_goods_nomenclature }

      it 'create Measure with Measure Components from TAME' do
        ChiefTransformer.instance.invoke(:initial_load)
        Measure.count.should == 1
        MeasureComponent.count.should == 1
      end
    end

    context 'MFCM & TAMF present' do
      let!(:chief_duty_expression) { create :chief_duty_expression, adval1_rate: 0,
                                                                    adval2_rate: 0,
                                                                    spfc1_rate: 1,
                                                                    spfc2_rate: 0 }
      let!(:mfcm) { create :mfcm, :with_tamf_components,
                                  :with_vat_group,
                                  :with_geographical_area,
                                  :with_goods_nomenclature }

      it 'creates Measure and Measure Components from TAMF' do
        ChiefTransformer.instance.invoke(:initial_load)
        Measure.count.should == 1
        MeasureComponent.count.should == 1
      end

      it 'create Measure Conditions from TAMF' do
        mfcm = create :mfcm, :with_tamf_conditions,
                             :with_goods_nomenclature,
                             msrgp_code: 'PR'

        ChiefTransformer.instance.invoke(:initial_load)
        Measure.count.should == 2
        MeasureCondition.count.should == 1
      end
    end
  end

  describe '#build' do
    it 'builds measures from Mfcm' do
      measures = ChiefTransformer::CandidateMeasure::Collection.build
    end

    it 'builds measures from Tame' do
    end

    it 'builds measures from Tamf' do
    end
  end
end
