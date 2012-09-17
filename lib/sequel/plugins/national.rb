module Sequel
  module Plugins
    module National
      module DatasetMethods
        def national
          where("#{model.primary_key} < 0").order(model.primary_key.desc)
        end
      end

      module ClassMethods
        def next_national_sid
          x_model = self.national.last
          if x_model
            sid = x_model.send(self.primary_key)
          else
            sid = 0
          end
          sid - 1
        end
      end
    end
  end
end

