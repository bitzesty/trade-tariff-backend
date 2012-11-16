Sequel.migration do
  up do
    Sequel::Model.db.run("UPDATE chief_tame SET le_tsmp = NULL WHERE le_tsmp = '0000-00-00 00:00:00'");
    Sequel::Model.db.run("UPDATE chief_mfcm SET le_tsmp = NULL WHERE le_tsmp = '0000-00-00 00:00:00'");
  end

  down do
    Sequel::Model.db.run("UPDATE chief_tame SET le_tsmp = '0000-00-00 00:00:00' WHERE le_tsmp IS NULL");
    Sequel::Model.db.run("UPDATE chief_mfcm SET le_tsmp = '0000-00-00 00:00:00' WHERE le_tsmp IS NULL");
  end
end
