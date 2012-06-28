class CreateQuotaAssociations < ActiveRecord::Migration
  def change
    create_table :quota_associations, :id => false do |t|
      t.integer :main_quota_definition_sid
      t.integer :sub_quota_definition_sid
      t.string :relation_type
      t.decimal :coefficient, :scale => 5, :precision => 16

      t.timestamps
    end
  end
end
