class CreatePublicationSigles < ActiveRecord::Migration
  def change
    create_table :publication_sigles, :id => false do |t|
      t.string :code_type_id
      t.string :code_type
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :publiction_code
      t.string :publication_sigle

      t.timestamps
    end
  end
end
