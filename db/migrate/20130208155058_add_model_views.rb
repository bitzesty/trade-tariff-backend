Sequel.migration do
  up do
    # NOTE this is class override
    # Measure in app/models has reference to RegulationReplacement in class level
    # when we trigger Measure.primary_key it searches for regulation_replacements
    # table which is still not created (m < r), so we just redefine plain model
    # here as we don't need anything on real Measure besides primary_key
    class Measure < Sequel::Model
      set_primary_key :measure_sid
    end

    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
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
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      view_name = table_name.to_s.split("_oplog").first
      drop_view view_name
    end
  end
end
