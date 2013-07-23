class ModificationRegulation < Sequel::Model
  plugin :oplog, primary_key: [:modification_regulation_id,
                               :modification_regulation_role]
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :effective_end_date
  plugin :conformance_validator

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

  one_to_one :base_regulation, key: [:base_regulation_id, :base_regulation_role],
                               primary_key: [:base_regulation_id, :base_regulation_role]

  # TODO confirm this assumption
  # 0 not replaced
  # 1 fully replaced
  # 2 partially replaced
  def fully_replaced?
    replacement_indicator == 1
  end
end
