require 'spec_helper'

describe ChiefTransformer::MeasureBuilder::MfcmBuilder do
  let(:mfcm)           { create :mfcm }
  let(:mfcm_with_tame) { create :mfcm, :with_tame}

  subject { ChiefTransformer::MeasureBuilder::MfcmBuilder }

  describe '.build' do
    it 'builds CandidateMeasures based on present Chief Mfcm records' do
      mfcm_with_tame

      result = subject.build
      result.should_not be_blank
      result.map(&:goods_nomenclature_item_id).should include mfcm_with_tame.cmdty_code
    end

    it 'does not build CandidateMeasures for Mfcm without related Tames' do
      mfcm

      subject.build.should be_blank
    end
  end
end
