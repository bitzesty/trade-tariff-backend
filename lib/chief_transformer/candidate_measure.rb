require 'chief_transformer/candidate_measure/collection'
require 'chief_transformer/candidate_measure/candidate_associations'
require 'chief_transformer/time'

class ChiefTransformer
  class CandidateMeasure < Sequel::Model
    set_dataset db[:measures]
    set_primary_key :measure_sid

    plugin :national

    DEFAULT_REGULATION_ROLE_TYPE_ID = 1
    DEFAULT_REGULATION_ID = "IYY99990"
    DEFAULT_GEOGRAPHICAL_AREA_ID = "1011" #ERGA OMNES

    EXCISE_GROUP_CODES = %w[EX]
    VAT_GROUP_CODES = %w[VT]
    RESTRICTION_GROUP_CODES = %w[DL PR DP DO HO]
    NATIONAL_MEASURE_TYPES = %w[AIL DPO EXA EXB EXC EXD DAA DAB DAC DAE DAI
                                    DBA DBB DBC DBE DBI DCA DCC DCE DCH DDJ DDA
                                    DDB DDC DDD DDE DDF DDG DEA DFA DFB DFC DGC
                                    DHA DHC DHE EAA EAE EBJ EBA EBB EBE EDJ EDA
                                    EDB EDE EEA EEF EFJ EFA EGJ EGA EGB EHI EIJ
                                    EIA EIB EIC EID EIE FAA FAE FAI FBC FBG LAA
                                    LAE LBJ LBA LBB LBE LDA LEA LEF LFA LGJ COE
                                    PRE AHC ATT CEX CHM COI CVD ECM EHC EQC EWP
                                    HOP HSE IWP PHC PRT QRC SFS VTA VTA VTE VTE
                                    VTS VTS VTZ VTZ]

    attr_accessor :mfcm, :tame, :tamf, :candidate_associations, :initiator, :operation
    attr_reader :chief_geographical_area

    delegate :persist, :map, to: :candidate_associations, prefix: true
    delegate :fe_tsmp, to: :tame, prefix: true

    def after_initialize
      # set default variables
      set({measure_generating_regulation_id: DEFAULT_REGULATION_ID,
           measure_generating_regulation_role: DEFAULT_REGULATION_ROLE_TYPE_ID,
           stopped_flag: false,
           national: true })

      # TODO geograhical area can come from either one of mfcm, tamf or tame
      set({geographical_area: DEFAULT_GEOGRAPHICAL_AREA_ID}) if geographical_area.blank?

      callbacks
    end

    # TODO refactor this
    def callbacks
      assign_dates if mfcm
      assign_mfcm_attributes if mfcm
      build_conditions if tamf
      build_components
      build_footnotes
    end

    def rebuild
      # clear pre-built
      @candidate_associations = CandidateAssociations.new(self)
      # re-run the drill
      callbacks
    end

    def validate
      super

      errors.add(:mfcm, 'must be set') if mfcm.blank?
      errors.add(:tame_tamf, 'tame or tamf must be set') if tame.blank? && tamf.blank?
      errors.add(:goods_nomenclature_item_id, 'commodity code should have 10 symbol length') if goods_nomenclature_item_id.present? && goods_nomenclature_item_id.size != 10
      errors.add(:measure_type, 'measure_type must be present') if measure_type.blank?
      errors.add(:measure_type, 'must have national measure type') if measure_type.present? && !measure_type.in?(NATIONAL_MEASURE_TYPES)
      errors.add(:goods_nomenclature_sid, 'must be present') if goods_nomenclature_sid.blank?
      errors.add(:geographical_area_sid, 'must be present') if geographical_area_sid.blank?
      errors.add(:validity_end_date, 'start date greater than end date') if validity_end_date.present? && validity_start_date >= validity_end_date
      errors.add(:measure_sid, 'measure must be unique') if Measure.where(measure_type: measure_type,
                                                                          geographical_area: geographical_area,
                                                                          validity_start_date: validity_start_date,
                                                                          validity_end_date: validity_end_date,
                                                                          goods_nomenclature_item_id: goods_nomenclature_item_id,
                                                                          additional_code_type: additional_code_type,
                                                                          additional_code: additional_code).national.any?

    end

    def assign_mfcm_attributes
      self.goods_nomenclature_item_id = (mfcm.cmdty_code.size == 8) ? "#{mfcm.cmdty_code}00" : mfcm.cmdty_code
      self.measure_type = mfcm.measure_type_adco.measure_type_id.presence || mfcm.msr_type
      self.additional_code = mfcm.measure_type_adco.adtnl_cd
      self.additional_code_type = mfcm.measure_type_adco.adtnl_cd_type_id
      self.tariff_measure_number = mfcm.tar_msr_no
    end

    def assign_dates
      assign_validity_start_date
      assign_validity_end_date
    end

    def audit_tsmp
      (tame.present?) ? tame.audit_tsmp : mfcm.audit_tsmp
    end

    def assign_validity_start_date
      self.validity_start_date =  if tamf.present?
                                    if Time.after(tamf.fe_tsmp, mfcm.fe_tsmp)
                                      tamf.fe_tsmp
                                    else
                                      mfcm.fe_tsmp
                                    end
                                  elsif tame.present?
                                    if Time.after(tame.fe_tsmp, mfcm.fe_tsmp)
                                      tame.fe_tsmp
                                    else
                                      mfcm.fe_tsmp
                                    end
                                  else
                                    mfcm.fe_tsmp
                                  end
    end

    def assign_validity_end_date
      self.validity_end_date =  if tame.present?
                                  if Time.after(tame.le_tsmp, mfcm.le_tsmp)
                                    mfcm.le_tsmp
                                  elsif tame.le_tsmp.present?
                                    tame.le_tsmp
                                  end
                                else
                                  mfcm.le_tsmp
                                end
    end

    def chief_geographical_area=(chief_code)
      @chief_geographical_area = chief_code

      self[:geographical_area] = (chief_code == DEFAULT_GEOGRAPHICAL_AREA_ID) ? chief_code : Chief::CountryCode.to_taric(chief_code)
    end

    def candidate_associations
      @candidate_associations ||= CandidateAssociations.new(self)
    end

    def before_validation
      # set excluded_country geographical area_sid
      # must happen after validity dates are set, depends on start date
      self.additional_code_sid = AdditionalCode.where(additional_code_type_id: additional_code_type,
                                                      additional_code: additional_code)
                                               .where("validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)", validity_start_date, validity_end_date)
                                               .first
                                               .try(:additional_code_sid)
      # needs to throw errors about invalid geographical area
      self.geographical_area_sid = GeographicalArea.where(geographical_area_id: geographical_area)
                                                   .where("validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)", validity_start_date, validity_end_date)
                                                   .first
                                                   .try(:geographical_area_sid)
      if self.geographical_area_sid.blank?
        self[:geographical_area] = DEFAULT_GEOGRAPHICAL_AREA_ID

        self.geographical_area_sid = GeographicalArea.where(geographical_area_id: geographical_area)
                                                     .where("validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)", validity_start_date, validity_end_date)
                                                     .first
                                                     .try(:geographical_area_sid)
      end

      # needs to throw errors about invalid goods nomenclature item found
      self.goods_nomenclature_sid = GoodsNomenclature.where(goods_nomenclature_item_id: goods_nomenclature_item_id)
                                                     .where("validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)", validity_start_date, validity_end_date)
                                                     .declarable
                                                     .order(:validity_start_date.desc)
                                                     .first
                                                     .try(:goods_nomenclature_sid)

      # assign negative, National sid before saving record
      self.measure_sid = self.class.next_national_sid

      super
    end

    def before_save
      # TODO move to proper place
      exclusion_entry = Chief::CountryGroup.where(chief_country_grp: chief_geographical_area).first
      if exclusion_entry.present? && exclusion_entry.country_exclusions.present?
        exclusion_entry.country_exclusions.split(",").each do |excluded_chief_code|
          excluded_geographical_area = GeographicalArea.where(geographical_area_id: Chief::CountryCode.to_taric(excluded_chief_code))
                                                       .latest
                                                       .first

          if excluded_geographical_area.present?
            exclusion = MeasureExcludedGeographicalArea.new do |mega|
              mega.geographical_area_sid = excluded_geographical_area.geographical_area_sid
              mega.excluded_geographical_area = excluded_geographical_area.geographical_area_id
            end

            candidate_associations.push(:excluded_geographical_areas, exclusion)
          end
        end
      end

      super
    end

    def is_vat_or_excise?
      mfcm.present? && (mfcm.msrgp_code.in?(EXCISE_GROUP_CODES) || mfcm.msrgp_code.in?(VAT_GROUP_CODES))
    end

    def is_vat?
      mfcm.present? && mfcm.msrgp_code.in?(VAT_GROUP_CODES)
    end

    def is_prohibition_or_restriction?
      mfcm.present? && (mfcm.msrgp_code.in?(RESTRICTION_GROUP_CODES))
    end

    def after_save
      # traverse associations hash, create association records
      candidate_associations_persist
    end

    private

    # TODO missing setting of update type
    def build_conditions
      tamf.measure_type_conds.each do |chief_measure_condition|
        taric_measure_condition = MeasureCondition.new do |mc|
          mc.action_code = chief_measure_condition.act_cd
          mc.certificate_code = chief_measure_condition.cert_ref_no
          mc.certificate_type_code = chief_measure_condition.cert_type_cd
          mc.condition_code = chief_measure_condition.cond_cd
          mc.component_sequence_number = chief_measure_condition.comp_seq_no
        end

        candidate_associations.push(:measure_conditions, taric_measure_condition)
      end

      self.chief_geographical_area = tamf.geographical_area.presence || DEFAULT_GEOGRAPHICAL_AREA_ID
    end

    def build_components
      if tamf.present?
        build_components_from_tamf if is_vat_or_excise?
      elsif tame.present?
        build_components_from_tame if is_vat_or_excise?
      end
    end

    def build_components_from_tame
      if mfcm.measure_type_adco.present?
        if tame.adval_rate.blank? || tame.adval_rate < 0
          tame.adval_rate = 0
        end

        measure_component = MeasureComponent.new do |mc|
          mc.duty_amount = tame.adval_rate
          if tame.duty_expression.present?
            mc.duty_expression_id = tame.duty_expression.duty_expression_id_adval1
          end
        end

        candidate_associations.push(:measure_components, measure_component)
      end
    end

    def build_components_from_tamf
      components = tamf.measure_components

      unless components.present?
        # if no components found - find components with present adval1_rate
        tamf.adval1_rate = 0.0
        components = tamf.measure_components
      end

      candidate_associations.push(:measure_components, components)
    end

    def build_footnotes
      footnote = Chief::MeasureTypeFootnote.where(measure_type_id: measure_type).first

      if footnote.present?
        fnasm = FootnoteAssociationMeasure.new do |fam|
          fam.footnote_type_id = footnote.footn_type_id
          fam.footnote_id = footnote.footn_id
          fam.national = true
        end

        candidate_associations.push(:footnote_association_measures, fnasm)
      end
    end
  end
end
