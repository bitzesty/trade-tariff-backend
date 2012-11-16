Sequel.migration do
  # Makes sure that there is only one TAME record per (msrgp_code, msr_type, tty_code, tar_msr_no) group that has blank validity end date.
  # Fixes CHIEF initial load.
  up do
    Chief::Tame.distinct(:msrgp_code, :msr_type, :tty_code)
               .where(tar_msr_no: nil).each do |ref_tame|
      tames = Chief::Tame.where(msrgp_code: ref_tame.msrgp_code,
                                msr_type: ref_tame.msr_type,
                                tty_code: ref_tame.tty_code)
                         .order(:fe_tsmp.asc)
                         .all
      blank_tames = tames.select{|tame| tame.le_tsmp.blank? }

      if blank_tames.size > 1
        blank_tames.each do |blank_tame|
          Chief::Tame.filter(blank_tame.pk_hash).update(le_tsmp: tames[tames.index(blank_tame)+1].fe_tsmp) unless blank_tame == tames.last
        end
      end
    end
  end

  down do
  end
end
