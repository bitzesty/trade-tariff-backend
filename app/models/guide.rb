class Guide < Sequel::Model
  many_to_many :chapters, left_key: :guide_id,
                          join_table: :chapters_guides
end
