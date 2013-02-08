require 'spec_helper'
require 'tariff_importer'
require 'active_support/log_subscriber/test_helper'

describe TariffImporter::Logger do
  include ActiveSupport::LogSubscriber::TestHelper

  before {
    setup # ActiveSupport::LogSubscriber::TestHelper.setup

    TariffImporter::Logger.attach_to :tariff_importer
    TariffImporter::Logger.logger = @logger
  }

  describe '#chief_imported logging' do
    let(:valid_file) { "spec/fixtures/chief_samples/KBT009\(12044\).txt" }

    before { ChiefImporter.new(valid_file).import }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Parsed (.*) CHIEF records/
    end
  end

  describe '#chief_failed logging' do
    let(:invalid_file) { "spec/fixtures/chief_samples/malformed_sample.txt" }

    before {
      rescuing { ChiefImporter.new(invalid_file).import }
    }

    it 'logs an info event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /CHIEF import (.*) failed/
    end
  end

  describe '#taric_failed logging' do
    let(:invalid_file) { "spec/fixtures/taric_samples/broken_insert_record.xml" }

    before {
      rescuing { TaricImporter.new(invalid_file).import }
    }

    it 'logs an info event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Taric import failed/
    end
  end

  describe '#taric_imported logging' do
    let(:valid_file) { "spec/fixtures/taric_samples/insert_record.xml" }

    before {
      ExplicitAbrogationRegulation.unrestrict_primary_key
      TaricImporter.new(valid_file).import
    }

    it 'logs an info event' do
      @logger.logged(:info).size.should eq 1
      @logger.logged(:info).last.should =~ /Successfully imported/
    end
  end

  describe '#taric_unexpected_update_type logging' do
    let(:unknown_file) { "spec/fixtures/taric_samples/unknown_record.xml" }

    it 'logs an info event' do
      rescuing { TaricImporter.new(unknown_file).import }

      @logger.logged(:error).size.should be >= 1
      @logger.logged(:error).first.should =~ /Unexpected Taric operation/
    end

    it 'raises ImportException' do
      expect { TaricImporter.new(unknown_file).import }.to raise_error TaricImporter::ImportException
    end
  end
end
