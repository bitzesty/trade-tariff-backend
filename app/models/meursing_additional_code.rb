class MeursingAdditionalCode < Sequel::Model
  plugin :oplog, primary_key: :meursing_additional_code_sid
  set_primary_key  :meursing_additional_code_sid
end


