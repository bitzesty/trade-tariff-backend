module Api
  module V2
    module Measures
      class MeasureSuspensionLegalActSerializer
        include FastJsonapi::ObjectSerializer

        set_type :suspension_legal_act

        set_id :regulation_id

        attribute :validity_end_date do |regulation|
          regulation.effective_end_date
        end

        attribute :validity_start_date do |regulation|
          regulation.effective_start_date
        end

        attribute :regulation_code do |regulation|
          ApplicationHelper.regulation_code(regulation)
        end

        attribute :regulation_url do |regulation|
          ApplicationHelper.regulation_url(regulation)
        end
      end
    end
  end
end
