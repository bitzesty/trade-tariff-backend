module Chief
  class CountryGroup < Sequel::Model
    set_dataset db[:chief_country_group]
  end
end
