class CreateComm < ActiveRecord::Migration
  def change
    create_table :comm, :id => false do |t|
      t.datetime :fe_tsmp
      t.string :cmdty_code
      t.datetime :le_tsmp
      t.string  :add_rlf_alwd_ind
      t.string  :alcohol_cmdty
      t.datetime :audit_tsmp
      t.string  :chi_doti_rqd
      t.string :cmdty_bbeer #not a typo
      t.string :cmdty_beer
      t.string :cmdty_euse_rfnd
      t.string :cmdty_mdecln
      t.string :exp_lcnc_rqd
      t.string :ex_ec_scode_rqd
      t.decimal :full_dty_adval1, :precision => 3, :scale => 3
      t.decimal :full_dty_adval2, :precision => 3, :scale => 3
      t.string :full_dty_exch
      t.decimal :full_dty_spfc1, :precision => 7, :scale => 4
      t.decimal :full_dty_spfc2,  :precision => 7, :scale => 4
      t.string  :full_dty_ttype
      t.string  :full_dty_uoq_c2
      t.string  :full_dty_uoq1
      t.string  :full_dty_uoq2
      t.string  :full_duty_type
      t.string  :im_ec_scode_rqd
      t.string  :imp_exp_use
      t.string  :nba_id
      t.string  :perfume_cmdty
      t.text  :rfa
      t.integer :season_end
      t.integer :season_start
      t.string  :spv_code
      t.string  :spv_xhdg
      t.string  :uoq_code_cdu1
      t.string  :uoq_code_cdu2
      t.string  :uoq_code_cdu3
      t.string  :whse_cmdty
      t.string  :wines_cmdty
    end
  end
end
