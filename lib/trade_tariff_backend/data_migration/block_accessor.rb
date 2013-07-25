module TradeTariffBackend
  class DataMigration
    module BlockAccessor
      extend ActiveSupport::Concern

      module ClassMethods
        def block_accessor(*names)
          names.each do |name|
            define_method(name) do |&block|
              if block
                instance_variable_set(:"@#{name}", block)
              else
                instance_variable_get(:"@#{name}").call
              end
            end
          end
        end
      end
    end
  end
end
