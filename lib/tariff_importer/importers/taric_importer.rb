require 'nokogiri'

require 'tariff_importer/importers/taric_importer/helpers/string_helper'

require 'tariff_importer/importers/taric_importer/strategies/base_strategy'
require 'tariff_importer/importers/taric_importer/strategies/strategies'

class TaricImporter
  include TaricImporter::Helpers::StringHelper

  class ImportException < StandardError; end
  module SourceParser
    # taric
    def from_source
      (is_path?) ? File.open(data, "r") : data
    end
  end

  cattr_accessor :opening_element
  self.opening_element = 1

  cattr_accessor :transaction_node
  self.transaction_node = 'env:transaction'

  cattr_accessor :ignored_strategies
  self.ignored_strategies = %w()

  attr_reader :data

  delegate :logger, to: ::TariffImporter

  def initialize(data)
    @data = data
  end

  def import
    begin
      reader = Nokogiri::XML::Reader(data.from_source)
      reader.each do |node|
        if node.name == self.transaction_node && node.node_type == self.opening_element
          xml = Nokogiri::XML.parse(node.outer_xml)
          xml.remove_namespaces!
          xml.xpath("//app.message").children.each do |mxml|
            unless mxml.text?
              begin
                node_name = mxml.xpath("record/update.type/following-sibling::*").first.node_name
                record_type = strategy_for(node_name)

                unless self.ignored_strategies.include?(record_type)
                  record_type.constantize.new(mxml).process!
                end
              rescue NameError => e
                print_error(mxml)

                raise TaricImportException
              rescue Exception => e
                logger.error e.message
                logger.error xml.to_xml(indent: 2)

                raise ImportException
              end
            end
          end
        end
      end
    rescue RuntimeError => e
      logger.error e.message

      raise ImportException
    end
  end

  private

  def strategy_for(entry_type)
    "TaricImporter::Strategies::#{as_strategy(entry_type)}".camelcase
  end

  def print_error(xml)
    puts "Can't handle transaction, strategy not defined:"
    puts xml.to_xml(indent: 2)
    puts "-" * 100
  end
end
