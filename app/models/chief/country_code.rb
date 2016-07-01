module Chief
  class CountryCode < Sequel::Model(:chief_country_code)

    def self.to_taric(chief_code)
      where(chief_country_cd: chief_code).first.try(:country_cd)
    end
  end
end
