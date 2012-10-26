class ModificationRegulation < Sequel::Model
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :effective_end_date

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

  one_to_one :base_regulation, key: [:base_regulation_id, :base_regulation_role]

  delegate :not_completely_abrogated, to: :base_regulation, prefix: true, allow_nil: true

  ######### Conformance validations 290
  def validate
    super
    # ROIMM1
    validates_unique([:modification_regulation_id, :modification_regulation_role])
    # TODO: ROIMM3
    # TODO: ROIMM4
    # ROIMM5
    validates_start_date
    # TODO: ROIMM6
    # TODO: ROIMM7
    # TODO: ROIMM8
    # TODO: ROIMM9
    # TODO: ROIMM10
    # TODO: ROIMM11
    # TODO: ROIMM12
    # TODO: ROIMM13
    # TODO: ROIMM34
    # TODO: ROIMM35
    # TODO: ROIMM36
    # TODO: ROIMM14
    # TODO: ROIMM15
    # TODO: ROIMM16
    # TODO: ROIMM17
    # TODO: ROIMM18
    # TODO: ROIMM19
    # TODO: ROIMM20
    # TODO: ROIMM21
    # TODO: ROIMM22
    # TODO: ROIMM23
    # TODO: ROIMM24
    # TODO: ROIMM25
    # TODO: ROIMM26
    # TODO: ROIMM27
    # TODO: ROIMM28
    # TODO: ROIMM29
    # TODO: ROIMM30
    # TODO: ROIMM31
    # TODO: ROAC4
    # TODO: ROAC6
    # TODO: ROAC7
    # TODO: ROAC9
    # TODO: ROAC10
    # TODO: ROAC11
    # TODO: ROAC16
    # TODO: ROAE4
    # TODO: ROAE6
    # TODO: ROAE7
    # TODO: ROAE9
    # TODO: ROAE11
    # TODO: ROAE12
    # TODO: ROAE19
  end

end


