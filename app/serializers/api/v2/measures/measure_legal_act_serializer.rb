module Api
  module V2
    module Measures
      class MeasureLegalActSerializer
        include FastJsonapi::ObjectSerializer
        set_id :regulation_id
        set_type :legal_act
        attributes :validity_start_date, :validity_end_date, :officialjournal_number,
                   :officialjournal_page, :published_date
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