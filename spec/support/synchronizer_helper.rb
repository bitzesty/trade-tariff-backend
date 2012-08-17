require 'fileutils'

module SynchronizerHelper
  mattr_accessor :sync_states
  self.sync_states = %w[inbox failbox processed]

  def create_taric_file(state, date = Date.today)
    raise "Invalid state requested" unless state.to_s.in?(sync_states)

    date = Date.parse(date.to_s)

    content = %Q{
      <?xml version="1.0" encoding="UTF-8"?>
      <env:envelope xmlns="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0" id="1">
        <env:transaction id="1">
          <app.message id="8">
            <transmission>
              <record>
                <transaction.id>2179611</transaction.id>
                <record.code>200</record.code>
                <subrecord.code>00</subrecord.code>
                <record.sequence.number>388</record.sequence.number>
                <update.type>3</update.type>
                <footnote>
                  <footnote.type.id>TM</footnote.type.id>
                  <footnote.id>127</footnote.id>
                  <validity.start.date>1972-01-01</validity.start.date>
                  <validity.end.date>1995-12-31</validity.end.date>
                </footnote>
              </record>
            </transmission>
          </app.message>
        </env:transaction>
      </env:envelope>
    }

    taric_file_path = File.join(TariffSynchronizer.send("#{state}_path".to_sym), "#{date}_TGB0001.xml")
    create_file taric_file_path, content

    Pathname.new(taric_file_path)
  end

  def create_chief_file(state, date = Date.today)
    raise "Invalid state requested" unless state.to_s.in?(sync_states)

    date = Date.parse(date.to_s)

    content = %Q{
      "AAAAAAAAAAA","01/01/1900:00:00:00"," ","20120312",
      "TAME       ","01/03/2012:00:00:00","U","PR","TFC",null,"03038931",null,null,null,null,"20/02/2012:09:34:00",null,null,"Y",null,"N",null,null,null,null,null,null,"Y",null,"N",null,null,null,"ITP BATCH INTERFACE",null,null,null,null,null,null,"N",
      "TAME       ","01/03/2012:00:00:00","U","DS","G","A10","16052190 45",null,null,null,null,"20/02/2012:09:40:00",null,null,"N",null,"N",null,null,null,null,null,null,"N",null,"N",null,null,null,"ITP BATCH INTERFACE",null,null,null,null,null,null,"N",
      "ZZZZZZZZZZZ","31/12/9999:23:59:59"," ",434,
    }

    chief_file_path = File.join(TariffSynchronizer.send("#{state}_path".to_sym),"#{date}_KBT009(#{date.strftime("%y")}#{date.yday}).txt")
    create_file chief_file_path, content

    Pathname.new(chief_file_path)
  end

  def prepare_synchronizer_folders
    sync_states.each do |state|
      FileUtils.mkdir_p File.join(Rails.root, TariffSynchronizer.send("#{state}_path".to_sym))
    end
  end

  def purge_synchronizer_folders
    sync_states.each do |state|
      FileUtils.rm_rf File.join(Rails.root, TariffSynchronizer.send("#{state}_path".to_sym))
    end
  end

  def data_folder_contains?(state, filename)
    File.exists?("#{TariffSynchronizer.send("#{state}_path".to_sym)}/#{filename}")
  end

  private

  def create_file(path, content)
    data_file = File.new(path, "w")
    data_file.write(content)
    data_file.close
  end
end
