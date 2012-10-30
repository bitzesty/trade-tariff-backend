class Language < Sequel::Model
  set_primary_key  :language_id

  ######### Conformance validations 130
  validates do
    # LA1
    uniqueness_of :language_id
    # LA3
    validity_dates
  end

  # LA2 - TODO
end


