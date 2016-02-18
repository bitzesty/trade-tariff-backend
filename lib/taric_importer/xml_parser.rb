module XmlParser
  class Reader < ::Ox::Sax

    def initialize(file_path, target, target_handler)
      @file_path = file_path
      @target = target
      @target_handler = target_handler
      @elements = []
    end

    def parse
      Ox.sax_parse self, IO.new(IO.sysopen @file_path), symbolize: false, strip_namespace: '*'
    end

    def start_element(name)
      name = replace_dots(name)
      @elements << { name=>{} }
    end

    def end_element(name)
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
      # Send element to the Class Handler
      if name == @target
        @target_handler.next_element @element
      end
    end

    def attr(name, value)
      return if name =~ %r{xmlns} # Exclude namespace attributes
      return unless @elements[-1]

      @elements[-1] ||= {}
      @elements[-1][name] = value
    end

    def text(value)
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
