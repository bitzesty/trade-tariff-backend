Sequel.migration do
  table_name = :publication_sigles_oplog
  # name of the view we are going to build
  view_name = table_name.to_s.split("_oplog").first

  up do
    create_table(table_name, ignore_index_errors: false) do
      String :code_type_id, size: 4
      String :code, size: 10
      String :publication_code, size: 1
      String :publication_sigle, size: 20

      DateTime :validity_end_date
      DateTime :validity_start_date

      DateTime :created_at
      # Oplog columns
      primary_key :oid
      String :operation, size: 1, default: 'C'
      Date :operation_date
    end

    # primary key of the view
    # from class that inherits from Sequel::Model
    pk = view_name.classify.constantize.primary_key
    # join conditions of primary_keys
    # necessary to build the view
    pk_assoc_hash = if pk.is_a?(Array)
                      pk.inject({}) { |memo, pk_part|
                        memo.merge!(:"#{view_name}1__#{pk_part}" => :"#{view_name}2__#{pk_part}")
                        memo
                      }
                    else
                      {:"#{view_name}1__#{pk}" => :"#{view_name}2__#{pk}"}
                    end

    # column names for the view
    # some columns from oplog are not necessary for the read view
    column_names = (Sequel::Model.db[table_name].columns - [:updated_at,
                                                            :created_at])

    create_or_replace_view(view_name, Sequel::Model.db[:"#{table_name}___#{view_name}1"]
                                          .select(*column_names)
                                          .where(:"#{view_name}1__oid" => Sequel::Model.db[:"#{table_name}___#{view_name}2"]
                                                                              .select(Sequel.function(:max, :oid))
                                                                              .where(pk_assoc_hash))
                                          .where{ Sequel.~(:"#{view_name}1__operation" => 'D') })
  end

  down do
    drop_view view_name
    drop_table table_name
  end
end
