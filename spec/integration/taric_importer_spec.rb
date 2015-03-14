require 'rails_helper'
require 'taric_importer'
require 'active_support/notifications'

describe TaricImporter do
  let(:example_date)      { Date.new(2013,8,2) }
  let(:taric_file_path)   {
    create_taric_file :pending, example_date do
%Q{<?xml version="1.0" encoding="UTF-8"?>
<env:envelope xmlns="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0" id="12091">
  <env:transaction id="13924773">
    <env:app.message id="2">
      <oub:transmission xmlns:oub="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0">
        <oub:record>
          <oub:transaction.id>13924773</oub:transaction.id>
          <oub:record.code>430</oub:record.code>
          <oub:subrecord.code>00</oub:subrecord.code>
          <oub:record.sequence.number>73</oub:record.sequence.number>
          <oub:update.type>3</oub:update.type>
          <oub:measure>
            <oub:measure.sid>3318239</oub:measure.sid>
            <oub:measure.type>475</oub:measure.type>
            <oub:geographical.area>US</oub:geographical.area>
            <oub:goods.nomenclature.item.id>1202410000</oub:goods.nomenclature.item.id>
            <oub:validity.start.date>2013-08-01</oub:validity.start.date>
            <oub:measure.generating.regulation.role>1</oub:measure.generating.regulation.role>
            <oub:measure.generating.regulation.id>D0800470</oub:measure.generating.regulation.id>
            <oub:stopped.flag>0</oub:stopped.flag>
            <oub:geographical.area.sid>103</oub:geographical.area.sid>
            <oub:goods.nomenclature.sid>94673</oub:goods.nomenclature.sid>
          </oub:measure>
        </oub:record>
      </oub:transmission>
    </env:app.message>
  </env:transaction>
</env:envelope>}
    end
  }

  let(:taric_update_path) {
    create_taric_file :pending, example_date do
%Q{<?xml version="1.0" encoding="UTF-8"?>
<env:envelope xmlns="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0" id="12091">
  <env:transaction id="13924773">
    <env:app.message id="2">
      <oub:transmission xmlns:oub="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0">
        <oub:record>
          <oub:transaction.id>13924773</oub:transaction.id>
          <oub:record.code>430</oub:record.code>
          <oub:subrecord.code>00</oub:subrecord.code>
          <oub:record.sequence.number>73</oub:record.sequence.number>
          <oub:update.type>1</oub:update.type>
          <oub:measure>
            <oub:measure.sid>3318239</oub:measure.sid>
            <oub:measure.type>475</oub:measure.type>
            <oub:geographical.area>US</oub:geographical.area>
            <oub:goods.nomenclature.item.id>1202410000</oub:goods.nomenclature.item.id>
            <oub:validity.start.date>2013-08-01</oub:validity.start.date>
            <oub:validity.end.date>2014-08-01</oub:validity.end.date>
            <oub:measure.generating.regulation.role>1</oub:measure.generating.regulation.role>
            <oub:measure.generating.regulation.id>D0800470</oub:measure.generating.regulation.id>
            <oub:stopped.flag>0</oub:stopped.flag>
            <oub:geographical.area.sid>103</oub:geographical.area.sid>
            <oub:goods.nomenclature.sid>94673</oub:goods.nomenclature.sid>
          </oub:measure>
        </oub:record>
      </oub:transmission>
    </env:app.message>
  </env:transaction>
</env:envelope>}
    end
  }

  before {
    prepare_synchronizer_folders

    Measure.unrestrict_primary_key
  }

  after  {
    purge_synchronizer_folders

    Measure.restrict_primary_key
  }

  it 'imports single Measure' do
    TaricImporter.new(taric_file_path, example_date).import

    expect(Measure.count).to eq 1
  end

  it 'imports single Measure and updates it' do
    TaricImporter.new(taric_file_path, example_date).import
    TaricImporter.new(taric_update_path, example_date).import

    expect(Measure.count).to eq 1
  end

  it 'creates single Measure::Operation(oplog) entry' do
    TaricImporter.new(taric_file_path, example_date).import

    expect(Measure::Operation.count).to eq 1
    expect(
      Measure::Operation.where(
        operation: 'C',
        measure_sid: '3318239',
        operation_date: example_date
      ).first
    ).to be_present
  end

  it 'creates two Measure::Operation(oplog) entries after update' do
    TaricImporter.new(taric_file_path, example_date).import
    TaricImporter.new(taric_update_path, example_date).import

    expect(Measure::Operation.count).to eq 2
    update = Measure::Operation.where(
        operation: 'U',
        measure_sid: '3318239',
        operation_date: example_date,
      ).first
    expect(update).to be_present
    expect(update.validity_end_date).to be_present
  end

  it 'emits conformance errors as ActiveSupport notifications' do
    bogus_records = []

    ActiveSupport::Notifications.subscribe /conformance_error/ do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      bogus_records << event.payload[:record]
    end

    TaricImporter.new(taric_file_path, example_date).import

    expect(bogus_records.size).to eq 1
  end
end
