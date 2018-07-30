module TariffSynchronizer
  class TariffUpdateDestroyError < Sequel::Model
    many_to_one :base_update, key: :tariff_update_filename, class: BaseUpdate

  end
end
