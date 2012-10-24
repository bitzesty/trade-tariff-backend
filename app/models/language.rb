class Language < Sequel::Model
  set_primary_key  :language_id

  ######### Conformance validations 130
  # LA2 - TODO
  def validate
    super
    # LA1
    validates_unique(:language_id)
    # LA3
    validates_start_date
  end
end


