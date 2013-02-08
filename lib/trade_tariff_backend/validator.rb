require 'trade_tariff_backend/validator/validation_definer'
require 'trade_tariff_backend/validator/validation_error'

module TradeTariffBackend
  class Validator
    def self.validations
      @validations ||= []
      @validations
    end

    def self.validation(identifiers, description, opts = {}, &block)
      validations << ValidationDefiner.define(identifiers, description, opts, &block)
    end

    def validations
      self.class.validations
    end

    def validate(record, active_validations = [])
      relevant_validations_for(record, active_validations).each {|validation|
        record.errors.add(:conformance, validation.to_s) unless validation.valid?(record)
      }
    end

    private

    def relevant_validations_for(record, active_validations = [])
      validations.reject{ |validation|
        active_validations.any? && ([validation.identifiers].flatten & active_validations).none?
      }.select{ |validation|
        validation.operations.include?(record.operation) &&
        validation.relevant_for?(record)
      }
    end
  end
end
