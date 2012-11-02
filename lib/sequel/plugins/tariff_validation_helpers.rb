module Sequel
  module Plugins
    module TariffValidationHelpers
      module ClassMethods
        def validates_validity_date_span_of(*atts)
          opts = {
            message: "%s does not span validity date of associated %s",
            tag: :validity_date_span,
          }.merge!(extract_options!(atts))

          reflect_validation(:validity_date_span, opts, atts)
          atts << opts

          validates_each(*atts) do |o, a, v|
            associated_record = o.send(a)
            error_message = opts[:message] % [o.class.name, associated_record.class.name]

            if associated_record.present?
              if o.validity_start_date.present? && associated_record.validity_start_date.present?
                 o.errors.add(a, error_message) if o.validity_start_date < associated_record.validity_start_date
              end
              if o.validity_end_date.present? && associated_record.validity_end_date.present?
                 o.errors.add(a, error_message) if o.validity_end_date > associated_record.validity_end_date
              end
            end
          end
        end

        def validates_validity_dates
          atts = [:validity_start_date, :validity_end_date]
          opts = {
            message: "validity end date must be greater or equal to validity start date",
            tag: :validity_date,
          }.merge!(extract_options!(atts))

          reflect_validation(:validity_date, opts, atts)
          atts << opts

          validates_each(*atts) do |o, a, v|
            if o.validity_start_date && o.validity_end_date && (o.validity_end_date < o.validity_start_date)
              o.errors.add(a, 'must be less then or equal to end date')
            end
          end
        end

        def validates_input_of(*atts)
         opts = {
            :message => "cannot be set unless condition is met",
            :requires => true,
            :tag => :input,
          }.merge!(extract_options!(atts))

          reflect_validation(:input, opts, atts)

          atts << opts
          validates_each(*atts) do |o, a, v|
            o.errors.add(a, opts[:message]) if o.send(a).present? && !o.send(opts[:requires])
          end
        end

        def validates_exclusion_of(*atts)
          opts = extract_options!(atts)
          n = opts[:from]
          unless n && (n.respond_to?(:cover?) || n.respond_to?(:include?))
            raise ArgumentError, "The :from parameter is required, and must respond to cover? or include?"
          end
          opts[:message] ||= "is in range or set: #{n.inspect}"
          reflect_validation(:exclusion, opts, atts)
          atts << opts
          validates_each(*atts) do |o, a, v|
            o.errors.add(a, opts[:message]) if n.send(n.respond_to?(:cover?) ? :cover? : :include?, v)
          end
        end

        def validates_associated(associations, config = {})
          atts = [associations].flatten

          opts = {
            message: "%s must be valid",
            tag: :associated,
          }.merge!(extract_options!(atts)).merge!(config)

          reflect_validation(:associated, opts, atts)
          atts << opts

          validates_each(*atts) do |object, association, value|
            if object.send(association).present?
              object.errors.add(association, opts[:message] % [association]) unless object.send(opts[:ensure])
            end
          end
        end
      end
    end
  end
end
