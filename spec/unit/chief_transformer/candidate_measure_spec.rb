require 'rails_helper'
require 'chief_transformer'

describe ChiefTransformer::CandidateMeasure do
  it 'should be a Sequel Model tied to Measures Oplog table' do
    expect(subject).to be_kind_of Sequel::Model
    expect(subject.class.table_name).to eq :measures_oplog
  end

  describe 'initialization' do
    it 'sets default values for UK measures' do
      expect(subject.measure_generating_regulation_id).to eq ChiefTransformer::CandidateMeasure::DEFAULT_REGULATION_ID
      expect(subject.measure_generating_regulation_role).to eq ChiefTransformer::CandidateMeasure::DEFAULT_REGULATION_ROLE_TYPE_ID
      expect(subject.geographical_area_id).to eq ChiefTransformer::CandidateMeasure::DEFAULT_GEOGRAPHICAL_AREA_ID
      expect(subject.stopped_flag).to be_falsy
      expect(subject.national).to be_truthy
    end
  end

  describe 'is_vat_or_excise?' do
    context 'vat mfcm' do
      let(:mfcm) { create :mfcm, :with_vat_group }
      subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }

      it "should return true if a vat or excise measure" do
        expect(candidate_measure.is_vat_or_excise?).to eq true
      end
    end
    context 'non vat mfcm' do
      let(:mfcm) { create :mfcm, :with_non_vat_group }
      subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }

      it "should return false if for some reason non vat measures exist" do
        expect(candidate_measure.is_vat_or_excise?).to eq false
      end
    end
  end

  describe 'validations' do
    subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new }

    it 'expects mfcm to be set' do
      expect(candidate_measure.valid?).to be_falsy
      expect(candidate_measure.errors).to include :mfcm
    end

    it 'expects either tame or tamf to be set' do
      expect(candidate_measure.valid?).to be_falsy
      expect(candidate_measure.errors).to include :tame_tamf
    end
  end

  describe 'mfcm=' do
    context 'mfcm cmdty code of length 10' do
      let(:mfcm) { create :mfcm }

      subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }

      it 'assigns validity start date using mfcm component' do
        expect(candidate_measure.validity_start_date).to eq mfcm.fe_tsmp
      end

      it 'assigns validity end date using mfcm component' do
        expect(candidate_measure.validity_end_date).to eq mfcm.le_tsmp
      end

      it 'assigns goods nomenclature item id using mfcm component' do
        expect(candidate_measure.goods_nomenclature_item_id).to eq mfcm.cmdty_code
      end

      it 'assigns measure type using chief measure type adco table' do
        expect(candidate_measure.measure_type_id).to eq mfcm.measure_type_adco.measure_type_id
      end
    end

    context 'mfcm cmdty code length of 8' do
      let(:mfcm) { create :mfcm, cmdty_code: "12345678" }

      subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }

      it 'pads commodity code with leading zeros' do
        expect(subject.goods_nomenclature_item_id).to eq "1234567800"
      end
    end
  end

  describe "geographical_area=" do
    subject { ChiefTransformer::CandidateMeasure }

    context 'settings default geographical area' do
      let(:default_geo_area) { ChiefTransformer::CandidateMeasure::DEFAULT_GEOGRAPHICAL_AREA_ID }

      it 'sets the default geographical area code' do
        candidate_measure = subject.new(geographical_area_id: default_geo_area)
        expect(candidate_measure.geographical_area_id).to eq default_geo_area
      end
    end

    context 'setting chief geographical area' do
      let!(:country_code) { create :country_code }

      let!(:excluded_country_code1) { create :country_code, country_cd: 'AB' }
      let!(:excluded_country_code2) { create :country_code, country_cd: 'DE' }

      let!(:country_group) { create :country_group, chief_country_grp: country_code.chief_country_cd,
                                                    country_exclusions: "#{excluded_country_code1.chief_country_cd},#{excluded_country_code2.chief_country_cd}" }

      let!(:geographical_area1) { create :geographical_area, geographical_area_id: excluded_country_code1.country_cd }
      let!(:geographical_area2) { create :geographical_area, geographical_area_id: excluded_country_code2.country_cd }

      let!(:mfcm) { create :mfcm }
      let!(:tame) { create :tame }

      let!(:geographical_area) { create :geographical_area, :fifteen_years, geographical_area_id: "1011" }
      let!(:goods_nomenclature) { create :commodity, :declarable, :fifteen_years, goods_nomenclature_item_id: mfcm.cmdty_code }

      it 'maps Geographical Area Chief code to Taric code' do
        candidate_measure = subject.new(chief_geographical_area: country_code.chief_country_cd)
        expect(candidate_measure.geographical_area_id).to eq country_code.country_cd # mapped to Taric country code
      end

      it 'builds country exclusion associations for geographical area if mapping present' do
        candidate_measure = subject.new(chief_geographical_area: country_code.chief_country_cd,
                                        tame: tame,
                                        mfcm: mfcm)
        candidate_measure.save
        expect(candidate_measure.candidate_associations).to have_key :excluded_geographical_areas
        expect(candidate_measure.candidate_associations[:excluded_geographical_areas].map(&:geographical_area_sid)).to include geographical_area1.geographical_area_sid
        expect(candidate_measure.candidate_associations[:excluded_geographical_areas].map(&:geographical_area_sid)).to include geographical_area2.geographical_area_sid
      end
    end
  end

  describe '#assign_dates' do
    describe 'assigning validity start date' do
      context 'tamf start date is after the mfcm' do
        let(:mfcm) { create :mfcm, :with_tame, :with_tamf }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                             tame: mfcm.tame,
                                                                             tamf: mfcm.tame.tamfs.first) }
        it "should use the tamf start date" do
          expect(candidate_measure.validity_start_date).to eq mfcm.tame.tamfs.first.fe_tsmp
        end
      end

      context 'tamf start date is before the mfcm' do
        let(:mfcm) { create :mfcm, :with_tame, :with_tamf_start_date_before }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                             tame: mfcm.tame,
                                                                             tamf: mfcm.tame.tamfs.first) }
        it "should use the mfcm start date" do
          expect(candidate_measure.validity_start_date).to eq mfcm.fe_tsmp
        end
      end

      context 'tamf absent, tame start date is before the mfcm' do
        let(:mfcm) { create :mfcm, :with_tame_start_date_before }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                         tame: mfcm.tame) }
        it "should use the mfcm start date" do
          expect(candidate_measure.validity_start_date).to eq mfcm.fe_tsmp
        end
      end

      context 'tamf & tame absent, although not sure when this would happen' do
        let(:mfcm) { create :mfcm }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }
        it "should use the mfcm start date" do
          expect(candidate_measure.validity_start_date).to eq mfcm.fe_tsmp
        end
      end
    end

    describe 'assigning validity end date' do
      context 'tame end date is after the mfcm' do
        let(:mfcm) { create :mfcm, :with_tame_end_date_after }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                         tame: mfcm.tame) }
        it "should use the mfcm end date" do
          expect(candidate_measure.validity_end_date).to eq mfcm.le_tsmp
        end
      end

      context 'tame end date is before the mfcm' do
        let(:mfcm) { create :mfcm, :with_tame_end_date_before }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                         tame: mfcm.tame) }
        it "should use the tame end date" do
          expect(candidate_measure.validity_end_date).to eq mfcm.tame.le_tsmp
        end
      end

      context 'tame absent with mfcm le_tsmp' do
        let(:mfcm) { create :mfcm, :with_le_tsmp }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }
        it "should use the mfcm end date" do
          expect(candidate_measure.validity_end_date).to eq mfcm.le_tsmp
        end
      end

      context 'tame absent with mfcm le_tsmp nil' do
        let(:mfcm) { create :mfcm }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }
        it "should be nil" do
          expect(candidate_measure.validity_end_date).to eq nil
        end
      end

      context 'when validity end date is assigned (any case)' do
        let(:mfcm) { create :mfcm, :with_le_tsmp }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }
        it 'sets justifications regulation role id and type (ME33, ME34 confirmance)' do
          expect(candidate_measure.justification_regulation_role).to_not be_blank
          expect(candidate_measure.justification_regulation_id).to_not be_blank
        end
      end
    end
  end

  describe "#assign_mfcm_attributes" do
    describe "assigning measure_type" do
      let(:mfcm) { create :mfcm, :with_tame, measure_type_id: 'AB' }

      it 'should assign measure type by referencing Chief::MeasureTypeAdco' do
        mfcm

        candidate_measure = ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                   tame: mfcm.tame)
        expect(candidate_measure.measure_type_id).to eq "AB"
      end
    end
  end

  describe 'building measure conditions' do
    let(:mfcm) { create :mfcm, :with_tamf_conditions }
    subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                         tame: mfcm.tame,
                                                                         tamf: mfcm.tame.tamfs.first) }
    it "should build the measure conditions from a tamf" do
      expect(candidate_measure.candidate_associations[:measure_conditions]).to_not be_blank
      expect(candidate_measure.candidate_associations[:measure_conditions].first.component_sequence_number).to eq 2
    end

  end

  describe 'building measure components' do
    context 'building from tame' do
      let!(:chief_duty_expression) { create :chief_duty_expression }
      let(:mfcm) { create :mfcm, :with_tame_components }
      subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                         tame: mfcm.tame) }
      it "should build the measure component from the tame" do
        expect(candidate_measure.candidate_associations[:measure_components]).to_not be_blank
        expect(candidate_measure.candidate_associations[:measure_components].first.duty_amount).to eq 20
      end
    end

    context 'building from tamf' do
      context 'duty expression present' do
        let!(:chief_duty_expression) { create :chief_duty_expression, adval1_rate: 0,
                                                                      adval2_rate: 0,
                                                                      spfc1_rate: 1,
                                                                      spfc2_rate: 0 }
        let!(:chief_measurement_unit) { create :chief_measurement_unit }
        let(:mfcm) { create :mfcm, :with_tamf_components }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                             tame: mfcm.tame,
                                                                             tamf: mfcm.tame.tamfs.first) }

        it "should build the measure component from the tamf" do
          expect(candidate_measure.candidate_associations[:measure_components]).to_not be_blank
        end
      end

      context 'duty expression blank' do
        let!(:chief_duty_expression) { create :chief_duty_expression, adval1_rate: 1,
                                                                      adval2_rate: 0,
                                                                      spfc1_rate: 0,
                                                                      spfc2_rate: 0 }
        let!(:chief_measurement_unit) { create :chief_measurement_unit }
        let!(:mfcm)  { create :mfcm, :with_tame, msrgp_code: ChiefTransformer::CandidateMeasure::EXCISE_GROUP_CODES.sample }
        let!(:tamf) { create :tamf, msrgp_code: mfcm.msrgp_code,
                                   msr_type: mfcm.msr_type,
                                   tty_code: mfcm.tty_code,
                                   fe_tsmp: mfcm.fe_tsmp }
        subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm,
                                                                             tame: mfcm.tame,
                                                                             tamf: mfcm.tame.tamfs.first) }

        it 'picks duty expression that matches adval1_rate being present condition' do
          expect(candidate_measure.candidate_associations[:measure_components]).to_not be_blank
        end
      end
    end
  end

  describe 'build footnotes' do
    let(:mfcm) { create :mfcm, :with_chief_measure_type_mapping }
    subject(:candidate_measure) { ChiefTransformer::CandidateMeasure.new(mfcm: mfcm) }

    it "according to measure type and chief measure type map" do
      expect(candidate_measure.candidate_associations[:footnote_association_measures]).to_not be_blank
    end
  end
end
