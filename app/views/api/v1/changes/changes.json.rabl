collection @changes

attributes :oid, :model_name, :operation_date, :operation

node(:record) { |change|
  partial "api/v1/#{change.to_partial_path}", object: change.record
}
