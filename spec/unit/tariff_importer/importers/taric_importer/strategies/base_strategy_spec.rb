require 'spec_helper'

require 'tariff_importer' # require it so that ActiveSupport requires get executed
require 'tariff_importer/importers/taric_importer'
require 'tariff_importer/importers/taric_importer/strategies/base_strategy'

class TaricImporter
  module Strategies
    class ExplicitAbrogationRegulation < BaseStrategy
    end
  end
end

class ExplicitAbrogationRegulation
end

describe TaricImporter::Strategies::BaseStrategy do
  describe 'initialization' do
    let(:import_xml) {
      file = File.open("spec/fixtures/taric_samples/insert_record.xml", "r")
      Nokogiri::XML(file).remove_namespaces!.xpath("//app.message/transmission").first
    }

    subject { TaricImporter::Strategies::BaseStrategy.new(import_xml) }

    it 'assigns operation' do
      subject.operation.should == :insert
    end

    it 'assigns attributes' do
      subject.attributes.should be_kind_of Hash
      subject.attributes['explicit_abrogation_regulation_role'].should == '7'
    end

    it 'assigns record attributes' do
      subject.record_attributes.should be_kind_of Hash
      subject.record_attributes[:record_code].should == '280'
      subject.record_attributes[:subrecord_code].should == '00'
      subject.record_attributes[:record_sequence_number].should == '1'
    end
  end

  describe "#process!" do
    context "local imports" do
      describe "creating records" do
        let(:import_xml) {
          file = File.open("spec/fixtures/taric_samples/insert_record.xml", "r")
          Nokogiri::XML(file).remove_namespaces!.xpath("//app.message/transmission").first
        }
        let(:model_mock) { mock(insert: true) }

        subject { TaricImporter::Strategies::ExplicitAbrogationRegulation.new(import_xml) }

        it 'calls Sequel record creation by default' do
          ExplicitAbrogationRegulation.expects(:model).returns(model_mock)

          subject.process!
        end
      end

      describe "update records" do
        let(:update_xml) {
          file = File.open("spec/fixtures/taric_samples/update_record.xml", "r")
          Nokogiri::XML(file).remove_namespaces!.xpath("//app.message/transmission").first
        }

        subject { TaricImporter::Strategies::ExplicitAbrogationRegulation.new(update_xml) }

        it 'calls Sequel record update by default' do
          update_stub = stub()
          ExplicitAbrogationRegulation.expects(:filter).returns(update_stub)
          update_stub.expects(:update).returns(true)

          subject.process!
        end
      end

      describe "delete records" do
        let(:delete_xml) {
          file = File.open("spec/fixtures/taric_samples/delete_record.xml", "r")
          Nokogiri::XML(file).remove_namespaces!.xpath("//app.message/transmission").first
        }

        subject { TaricImporter::Strategies::ExplicitAbrogationRegulation.new(delete_xml) }

        it 'calls Sequel record deletion by default' do
          destroy_stub = stub()
          ExplicitAbrogationRegulation.expects(:filter).returns(destroy_stub)
          destroy_stub.expects(:delete).returns(true)

          subject.process!
        end
      end
    end
  end
end

