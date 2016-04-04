require "rails_helper"
require "taric_importer"

describe TaricImporter do
  let(:example_date) { Date.new(2013,8,2) }
  let(:taric_file_path) { "spec/fixtures/taric_samples/create_measure.xml" }
  let(:taric_update_path) { "spec/fixtures/taric_samples/update_measure.xml" }

  before { Measure.unrestrict_primary_key }
  after { Measure.restrict_primary_key }

  it "imports single Measure" do
    TaricImporter.new(taric_file_path, example_date).import
    expect(Measure.count).to eq 1
  end

  it "imports single Measure and updates it" do
    TaricImporter.new(taric_file_path, example_date).import
    TaricImporter.new(taric_update_path, example_date).import
    expect(Measure.count).to eq 1
  end

  it "creates single Measure::Operation(oplog) entry" do
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

  it "creates two Measure::Operation(oplog) entries after update" do
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

  it "emits conformance errors as ActiveSupport notifications" do
    bogus_records = []
    ActiveSupport::Notifications.subscribe /conformance_error/ do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      bogus_records << event.payload[:record]
    end

    TaricImporter.new(taric_file_path, example_date).import
    expect(bogus_records.size).to eq 1
  end
end
