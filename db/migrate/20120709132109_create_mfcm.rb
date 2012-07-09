class CreateMfcm < ActiveRecord::Migration
  def change
    create_table :mfcm, :id => false do |t|
      t.datetime :fe_tsmp
      t.string :msrgp_code
      t.string :msr_type
      t.string :tty_code
      t.datetime :le_tsmp
      t.datetime :audit_tsmp
      t.string  :cmdty_code
      t.string :cmdty_msr_xhdg
      t.string :null_tri_rqd
      t.boolean :exports_use_ind
    end
  end
end