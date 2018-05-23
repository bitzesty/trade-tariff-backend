#
# We are relying on CDS files structure, all target elements have depth == 3
#

class CdsImporter
  module XmlParser
    class Reader < ::Ox::Sax
      def initialize(stringio, target, target_handler)
        @stringio = stringio
        @target = target
        @target_handler = target_handler
        @in_target = false
        @stack = []
        @depth = 0
      end

      def parse
        Ox.sax_parse self, @stringio, symbolize: false, strip_namespace: '*'
      end

      def start_element(key)
        puts "Key: start #{key}, depth #{@depth}" if @depth == 3
        @depth += 1

        # TODO: if depth == 3 and key is in mapping_root list
        # mapping_root list is mapping_root attr for CdsImporter::EntityMapper.constants

        @in_target = true if key == @target
        return unless @in_target

        @stack << @node = {}
      end

      def text(val)
        return unless @in_target
        @node[:__content__] = val
      end

      def end_element(key)
        @depth -= 1
        puts "Key: end #{key}, depth #{@depth}" if @depth == 3

        # TODO: if depth == 3 and key is in mapping_root list
        # mapping_root list is mapping_root attr for CdsImporter::EntityMapper.constants


        if key == @target
          @target_handler.process_xml_node @stack[-1]
          @in_target = false
        end

        return unless @in_target

        child = @stack.pop
        @node = @stack.last

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
    end
  end
end
