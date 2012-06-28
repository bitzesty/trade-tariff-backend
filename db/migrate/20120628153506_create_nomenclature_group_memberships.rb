class CreateNomenclatureGroupMemberships < ActiveRecord::Migration
  def change
    create_table :nomenclature_group_memberships, :id => false do |t|
      t.integer :goods_nomenclature_sid
      t.string :goods_nomenclature_group_type
      t.string :goods_nomenclature_group_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
