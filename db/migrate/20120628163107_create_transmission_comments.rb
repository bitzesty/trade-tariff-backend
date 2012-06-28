class CreateTransmissionComments < ActiveRecord::Migration
  def change
    create_table :transmission_comments, :id => false do |t|
      t.integer :comment_sid
      t.string :language_id
      t.text :comment_text

      t.timestamps
    end
  end
end
