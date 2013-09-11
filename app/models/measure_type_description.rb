class MeasureTypeDescription < Sequel::Model
  set_primary_key [:measure_type_id]
  plugin :oplog, primary_key: :measure_type_id
  plugin :conformance_validator

  one_to_one :measure_type, key: :measure_type_id,
                            foreign_key: :measure_type_id

  def changes(conditions = {})
    operation_klass.select(
      Sequel.as('MeasureTypeDescription', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(2, :depth)
    ).where(pk_hash)
     .where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end

  def to_s
    description
  end
end


