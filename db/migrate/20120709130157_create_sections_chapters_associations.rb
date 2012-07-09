class CreateSectionsChaptersAssociations < ActiveRecord::Migration
  def change
    create_table :chapters_sections do |t|
      t.integer :goods_nomenclature_sid
      t.references :section
    end

    add_index :chapters_sections, [:goods_nomenclature_sid, :section_id], unique: true
  end
end
