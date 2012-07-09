class CreateTamf < ActiveRecord::Migration
  def change
    create_table :tamf, :id => false do |t|
      t.datetime :fe_tsmp
      t.string :msgrp_code
      t.string :msr_type
      t.string :tty_code
      t.string :tar_msr_no
      t.datetime :le_tsmp
      t.decimal :adval1_rate, :precision => 3, :scale => 3
      t.decimal :adval2_rate, :precision => 3, :scale => 3
      t.string  :ai_factor
      t.decimal :cmdty_dmql, :precision => 8, :scale => 3
      t.string  :cmdty_dmql_uoq
      t.string  :cngp_code
      t.string  :cntry_disp
      t.string  :cntry_orig
      t.string  :duty_type
      t.string  :ec_supplement
      t.string  :ec_exch_rate
      t.string  :spcl_inst
      t.string  :spfc1_cmpd_uoq
      t.decimal  :spfc1_rate, :precision => 7, :scale => 4
      t.string  :spfc1_uoq
      t.decimal :spfc2_rate, :precision => 7, :scale => 4
      t.string  :spfc2_uoq
      t.decimal :spfc3_rate, :precision => 7, :scale => 4
      t.string  :spfc3_uoq
      t.string  :tamf_dt
      t.string  :tamf_sta
      t.string  :tamf_ty
    end
  end
end