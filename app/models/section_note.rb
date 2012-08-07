class SectionNote < Sequel::Model
  plugin :json_serializer

  many_to_one :section
end
