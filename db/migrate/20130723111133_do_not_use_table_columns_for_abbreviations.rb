Sequel.migration do
  up do
    alter_table :duty_expression_descriptions_oplog do
      drop_column :abbreviation
    end

    alter_table :monetary_unit_descriptions_oplog do
      drop_column :abbreviation
    end

    [:duty_expression_descriptions_oplog, :monetary_unit_descriptions_oplog].each do |table_name|
      # name of the view we are going to build
      view_name = table_name.to_s.split("_oplog").first
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
                                                                                       .where(pk_assoc_hash)
                                                                                       .order(Sequel.desc(:oid))).where{ Sequel.~(:"#{view_name}1__operation" => 'D') })
    end
  end

  down do
    alter_table :duty_expression_descriptions_oplog do
      add_column :abbreviation, String
    end

    alter_table :monetary_unit_descriptions_oplog do
      add_column :abbreviation, String
    end

    [:duty_expression_descriptions_oplog, :monetary_unit_descriptions_oplog].each do |table_name|
      # name of the view we are going to build
      view_name = table_name.to_s.split("_oplog").first
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
                                                                                       .where(pk_assoc_hash)
                                                                                       .order(Sequel.desc(:oid))).where{ Sequel.~(:"#{view_name}1__operation" => 'D') })
    end
  end
end
