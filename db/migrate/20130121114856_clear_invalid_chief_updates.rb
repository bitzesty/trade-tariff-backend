Sequel.migration do
  up do
    run "DELETE FROM `tariff_updates` WHERE ((`tariff_updates`.`update_type` IN ('TariffSynchronizer::ChiefUpdate')) AND (`issue_date` >= '2013-01-01') AND (`state` = 'M'))"
  end

  down do
  end
end
