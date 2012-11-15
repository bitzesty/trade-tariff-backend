require 'nokogiri'

require 'tariff_importer/importers/taric_importer/helpers/string_helper'

require 'tariff_importer/importers/taric_importer/strategies/base_strategy'
require 'tariff_importer/importers/taric_importer/strategies/strategies'

class TaricImporter
  include TaricImporter::Helpers::StringHelper

  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "TaricImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  cattr_accessor :opening_element
  self.opening_element = 1

  cattr_accessor :transaction_node
  self.transaction_node = 'env:transaction'

  cattr_accessor :ignored_strategies
  self.ignored_strategies = %w()

  cattr_accessor :sample_mode
  self.sample_mode = ENV['SAMPLE'].presence || false

  cattr_accessor :sample_count
  self.sample_count = ENV['SAMPLE_COUNT'].presence.try(:to_i) || 0

  attr_reader :path, :samples

  delegate :logger, to: ::TariffImporter

  def initialize(path)
    @path = path
    @samples = {}
  end

  def import
    begin
      handler = File.open(path, "r")
      reader = Nokogiri::XML::Reader(handler)
      reader.each do |node|
        if node.name == self.transaction_node && node.node_type == self.opening_element
          xml = Nokogiri::XML.parse(node.outer_xml)
          xml.remove_namespaces!
          xml.xpath("//app.message").children.each do |mxml|
            unless mxml.text?
              begin
                node_name = mxml.xpath("record/update.type/following-sibling::*").first.node_name
                record_type = strategy_for(node_name)

                sample(node_name, mxml) if self.sample_mode

                unless self.ignored_strategies.include?(record_type)
                  record_type.constantize.new(mxml).process!
                end
              rescue NameError => e
                print_error(mxml)

                raise ImportException.new(e.message, e)
              rescue Exception => e
                logger.error e.message
                logger.error xml.to_xml(indent: 2)

                raise ImportException.new(e.message, e)
              end
            end
          end
        end
      end
    rescue RuntimeError => e
      logger.error e.message

      raise ImportException.new(e.message, e)
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

  def sample(node_name, xml)
    if samples.has_key?(node_name)
      samples[node_name] += 1

      unless samples[node_name] > self.sample_count
        File.open("samples/#{node_name.parameterize("_")}_#{samples[node_name]}.xml",'w') {|f|
          f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
          xml.write_to(f, encoding: 'UTF-8')
        }
      end
    else
      samples[node_name] = 1

      File.open("samples/#{node_name.parameterize("_")}.xml",'w') {|f|
        f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
        xml.write_to(f, encoding: 'UTF-8')
      }
    end
  end
end
