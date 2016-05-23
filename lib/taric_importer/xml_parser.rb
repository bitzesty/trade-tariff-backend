module XmlParser
  class Reader < ::Ox::Sax

    def initialize(stringio, target, target_handler)
      @stringio = stringio
      @target = target
      @target_handler = target_handler
      @in_target = false
      @elements = []
    end

    def parse
      Ox.sax_parse self, @stringio, symbolize: false, strip_namespace: '*'
    end

    def start_element(name)
      @in_target = true if name == @target

      return unless @in_target
      name = replace_dots(name)
      @elements << { name=>{} }
    end

    def end_element(name)
      if @in_target
        name = replace_dots(name)
        if @elements[-1][name]
          @element = @elements.pop

          @element.delete name

          if @element.keys.size == 1 and @element[:text]
            inject_into_last name, @element[:text]
          else
            inject_into_last name, @element
          end
        end
      end

      if name == @target
        # Send element to the Class Handler
        @target_handler.process_xml_node @element
        @in_target = false
      end
    end

    def attr(name, value)
      return unless @in_target
      return if name =~ %r{xmlns} # Exclude namespace attributes
      return unless @elements[-1]

      @elements[-1] ||= {}
      @elements[-1][name] = value
    end

    def text(value)
      return unless @in_target
      return unless @elements[-1]
      @elements[-1][:text] = value
    end

    private

    def inject_into_last name, value
      return unless @elements[-1]

      if @elements[-1][name]
        @elements[-1][name] = [ @elements[-1][name] ] unless @elements[-1][name].is_a? Array
        @elements[-1][name] << value

      else
        @elements[-1][name] = value
      end
    end

    def replace_dots(name)
      # Rails requires name attributes with underscore
      name.tr(".".freeze, "_".freeze)
    end
  end
end
