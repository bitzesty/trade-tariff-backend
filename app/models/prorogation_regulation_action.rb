class ProrogationRegulationAction < ActiveRecord::Base
  self.primary_key = [:prorogation_regulation_role, :prorogation_regulation_id,
                      :prorogated_regulation_role, :prorogated_regulation_id]
end
