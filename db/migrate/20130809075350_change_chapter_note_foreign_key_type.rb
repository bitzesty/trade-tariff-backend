Sequel.migration do
  up do
    alter_table :chapter_notes do
      set_column_type :chapter_id, String, size: 2
    end

    # prefix with leading zero chapters with id < 10
    self[:chapter_notes].all do |chapter_note|
      self[:chapter_notes].filter(content: chapter_note[:content]).update(chapter_id: sprintf("%02d", chapter_note[:chapter_id].to_i))
    end
  end

  down do
    alter_table :chapter_notes do
      set_column_type :chapter_id, Integer
    end
  end
end
