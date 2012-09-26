require 'spec_helper'
require 'chief_transformer/measure_builder'
require 'chief_transformer/measure_builders/mfcm_builder'

describe ChiefTransformer::MeasureBuilder do
  subject { ChiefTransformer::MeasureBuilder }

  describe '.build' do
    let(:mfcm_builder) { ChiefTransformer::MeasureBuilder::MfcmBuilder }

    it 'builds measures with specified builder' do
      mfcm_builder.expects(:build).returns(true)

      subject.build(mfcm_builder)
    end

    it 'raises TransformException if invalid builder specified' do
      expect { subject.build(nil) }.to raise_exception ChiefTransformer::TransformException
    end

    it 'passes arguments down to builder' do
      mfcm_builder.expects(:build).with(:abc, :def).returns(true)

      subject.build(mfcm_builder, :abc, :def)
    end
  end

  describe '.build_all' do
    let(:builder1) { stub }
    let(:builder2) { stub }
    let(:builders) { [builder1, builder2] }

    before {
      builders.each{ |b| b.expects(:build).returns(true) }
      ChiefTransformer::MeasureBuilder.expects(:builders).at_least(1).returns(builders)
    }

    it 'builds measures from all available builders' do
      subject.build_all
    end
  end
end
