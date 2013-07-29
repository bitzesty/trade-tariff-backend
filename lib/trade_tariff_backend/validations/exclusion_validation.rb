module TradeTariffBackend
  module Validations
    class ExclusionValidation < GenericValidation
      def valid?(record = nil)
        exclude_from = validation_options[:from]
        exclusion_of = validation_options[:of]

        raise ArgumentError.new('validates :exclusion expects {from: ARRAY} and {of: :symbol} to be passed in with options') if exclude_from.blank? || exclusion_of.blank?

        exclude_from = (exclude_from.is_a?(Proc) ? exclude_from.call : exclude_from)
        attribute_values = [exclusion_of].flatten.map{|att| record.send(att) }

        # Could be Sequel dataset similar to:
        #
        # CompleteAbrogationRegulation.select(:complete_abrogation_regulation_id,
        #                                     :complete_abrogation_regulation_role)
        if exclude_from.is_a?(Sequel::Dataset)
          # Becomes
          # CompleteAbrogationRegulation.select(:complete_abrogation_regulation_id,
          #                                     :complete_abrogation_regulation_role)
          #                             .filter(complete_abrogation_regulation_id: attribute_value1,
          #                                     complete_abrogiation_regulation_role: attribute_value2)
          #                             .none?
          query = Hash[exclude_from.columns.zip(attribute_values)]
          exclude_from.filter(query).none?
        else
          (exclude_from & attribute_values).none?
        end
      end
    end
  end
end
