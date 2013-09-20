module Chief
  class CountryGroup < Sequel::Model
    set_dataset db[:chief_country_group]

    def self.to_taric(chief_code)
      where(chief_country_grp: chief_code).first.try(:country_grp_region)
    end
  end
end
