Sequel.migration do
  change do
    create_table :chief_tbl9 do
      DateTime :fe_tsmp
      String   :amend_indicator, size: 1
      String   :tbl_type, size: 4
      String   :tbl_code, size: 10
      Integer  :txtlnno
      String   :tbl_txt, size: 100
    end
  end
end
