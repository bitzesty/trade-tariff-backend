namespace :tariff do
  namespace :measures do
    desc "Update measures#effective_start_date and measures#effective_end_date columns"
    task update_effective_dates: :environment do
      TradeTariffBackend.update_measure_effective_dates
    end
  end
end
