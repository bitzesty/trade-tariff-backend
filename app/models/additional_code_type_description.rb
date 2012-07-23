class AdditionalCodeTypeDescription < Sequel::Model
  set_primary_key :additional_code_type_id

  many_to_one :additional_code_type, key: :additional_code_type_id
  many_to_one :language
end


