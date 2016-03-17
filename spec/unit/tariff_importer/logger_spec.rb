require 'rails_helper'
require 'tariff_importer'

describe TariffImporter::Logger do
  before { tariff_importer_logger_listener }

  describe '#chief_imported' do
    it 'logs an info event with count date and path' do
      log = TariffImporter::Logger.new.chief_imported(chief_imported_event)
      expect(log[0]).to eq "Parsed 5 CHIEF records for 2012-12-21 at file.xml"
    end
  end

  describe '#chief_failed logging' do
    let(:invalid_file) { "spec/fixtures/chief_samples/malformed_sample.txt" }

    before {
      rescuing { ChiefImporter.new(invalid_file).import }
    }

    it 'logs an info event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /CHIEF import (.*) failed/
    end
  end

  describe '#taric_failed logging' do
    let(:invalid_file) { "spec/fixtures/taric_samples/broken_insert_record.xml" }

    before {
      rescuing { TaricImporter.new(invalid_file).import }
    }

    it 'logs an info event' do
      expect(@logger.logged(:error).size).to eq 1
      expect(@logger.logged(:error).last).to match /Taric import failed/
    end
  end

  describe '#taric_imported logging' do
    let(:valid_file) { "spec/fixtures/taric_samples/insert_record.xml" }

    before {
      ExplicitAbrogationRegulation.unrestrict_primary_key
      TaricImporter.new(valid_file).import
    }

    it 'logs an info event' do
      expect(@logger.logged(:info).size).to eq 1
      expect(@logger.logged(:info).last).to match /Successfully imported/
    end
  end

  describe '#taric_unexpected_update_type logging' do
    let(:unknown_file) { "spec/fixtures/taric_samples/unknown_record.xml" }

    it 'logs an info event' do
      rescuing { TaricImporter.new(unknown_file).import }

      expect(@logger.logged(:error).size).to be >= 1
      expect(@logger.logged(:error).first).to match /Unexpected Taric operation/
    end

    it 'raises ImportException' do
      expect { TaricImporter.new(unknown_file).import }.to raise_error TaricImporter::ImportException
    end
  end

  def chief_imported_event
    double("event", payload: {count: '5', date: '2012-12-21', path: 'file.xml'})
  end
end
