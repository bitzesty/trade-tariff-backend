class CreateTame < ActiveRecord::Migration
  def change
    create_table :chief_tame, :id => false do |t|
      t.datetime :fe_tsmp
      t.string :msrgp_code
      t.string :msr_type
      t.string :tty_code
      t.string :tar_msr_no
      t.datetime :le_tsmp
      t.decimal :adval_rate, :precision => 3, :scale => 3
      t.decimal :alch_sgth, :precision => 3, :scale => 2
      t.datetime :audit_tsmp
      t.string :cap_ai_stmt
      t.decimal :cap_max_pct, :precision => 3, :scale => 3
      t.string :cmdty_msr_xhdg
      t.string :comp_mthd
      t.string :cpc_wvr_phb
      t.string :ec_msr_set
      t.string :mip_band_exch
      t.string :mip_rate_exch
      t.string :mip_uoq_code
      t.string :nba_id
      t.string :null_tri_rqd
      t.string :qta_code_uk
      t.string :qta_elig_useLstrubg
      t.string :qta_exch_rate
      t.string :qta_no
      t.string :qta_uoq_code
      t.text :rfa
      t.string :rfs_code_1
      t.string :rfs_code_2
      t.string :rfs_code_3
      t.string :rfs_code_4
      t.string :rfs_code_5
      t.string :tdr_spr_sur
      t.boolean :exports_use_ind
    end
  end
end
