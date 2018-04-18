require 'ox'

class CdsImporter
  attr_reader :cds_update_file

  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "CdsImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  class UnknownOperationError < ImportException
  end

  def initialize(cds_update_file)
    @cds_update_file = cds_update_file
  end

  # we assume that all updates are valid
  def import
    XmlHandler.new(file_as_stringio).parse

    ActiveSupport::Notifications.instrument("cds_imported.tariff_importer",
                                            filename: @cds_update.filename)
  end

  def file_as_stringio
    if Rails.env.production?
      bucket.object(cds_update_file.file_path).get.body
    else
      StringIO.new(File.read(cds_update_file))
    end
  end

  class XmlHandler < ::Ox::Sax
    def initialize(stringio)
      @stringio = stringio
      @node_of_interest = false
      @stack = []
      @target = nil
    end

    def parse
      Ox.sax_parse self, @stringio, symbolize: false, strip_namespace: '*'
    end

    def start_element(name)
      binding.pry if name == 'AdditionalCodeType'
      if @node_of_interest == false && CdsImporter::EntityMapper.exist?(name)
        @target = name
        @node_of_interest = true
      end

      @stack << @node = {}
    end

    def end_element(key)
      binding.pry if key == 'AdditionalCodeType'
      if key == @target
        binding.pry
        XmlProcessor.new.process_xml_node(key, @stack[-1])
        @node_of_interest = false
      end

      binding.pry

      return unless @node_of_interest

      child = @stack.pop
      @node = @stack.last

      key = replace_dots(key)

      case @node[key]
      when Array
        @node[key] << child
      when Hash
        @node[key] = [@node[key], child]
      else
        if child.keys == [:__content__]
          @node[key] = child[:__content__]
        else
          @node[key] = child
        end
      end
    end

    def text(value)
      puts "text #{value}"
      return unless @node_of_interest
      @node[:__content__] = value
    end

    private

    def replace_dots(key)
      # Rails requires name attributes with underscore
      key.tr(".".freeze, "_".freeze)
    end
  end

  class XmlProcessor
    def initialize
      @issue_date = DateTime.now
    end

    def process_xml_node(node_name, hash_from_node)
      begin
        binding.pry
        # TODO:
        # do the mapping and create record in db

      rescue StandardError => exception
        ActiveSupport::Notifications.instrument("cds_failed.tariff_importer", exception: exception, hash: hash_from_node)
        raise ImportException.new
      end
    end
  end
end
