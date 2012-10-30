class BaseRegulation < Sequel::Model
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date

  set_primary_key [:base_regulation_id, :base_regulation_role]

  one_to_one :complete_abrogation_regulation, key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]

  def not_completely_abrogated?
    complete_abrogation_regulation.blank?
  end

  ######### Conformance validations 285
  validates do
    # ROIMB1
    uniqueness_of [:base_regulation_id, :base_regulation_role]
    # ROIMB3
    validity_dates
    # TODO: ROIMB4
    # TODO: ROIMB5
    # TODO: ROIMB6
    # TODO: ROIMB7
    # TODO: ROIMB48
    # TODO: ROIMB44
    # TODO: ROIMB46
    # TODO: ROIMB47
    # TODO: ROIMB8
    # TODO: ROIMB9
    # TODO: ROIMB10
    # TODO: ROIMB11
    # TODO: ROIMB12
    # TODO: ROIMB13
    # TODO: ROIMB14
    # TODO: ROIMB15
    # TODO: ROIMB16
    # TODO: ROIMB17
    # TODO: ROIMB18
    # TODO: ROIMB19
    # TODO: ROIMB20
    # TODO: ROIMB21
    # TODO: ROIMB22
    # TODO: ROIMB23
    # TODO: ROIMB24
    # TODO: ROIMB25
    # TODO: ROIMB26
    # TODO: ROIMB27
    # TODO: ROIMB28
    # TODO: ROIMB29
    # TODO: ROIMB30
    # TODO: ROIMB31
    # TODO: ROIMB32
    # TODO: ROIMB33
    # TODO: ROIMB34
    # TODO: ROIMB35
    # TODO: ROIMB36
    # TODO: ROIMB37
    # TODO: ROIMB38
    # TODO: ROIMB39
    # TODO: ROIMB40
    # TODO: ROIMB41
    # TODO: ROIMB43
    # TODO: ROAC4
    # TODO: ROAC6
    # TODO: ROAC7
    # TODO: ROAC8
    # TODO: ROAC10
    # TODO: ROAE4
    # TODO: ROAE6
    # TODO: ROAE7
    # TODO: ROAE8
    # TODO: ROAE11
  end
end


