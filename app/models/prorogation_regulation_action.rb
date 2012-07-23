class ProrogationRegulationAction < Sequel::Model
  set_primary_key  :prorogation_regulation_id, :prorogation_regulation_role,
                   :prorogated_regulation_id, :prorogated_regulation_role

  # belongs_to :prorogation_regulation, foreign_key: [:prorogation_regulation_id,
  #                                                   :prorogation_regulation_role]
  # belongs_to :prorogated_regulation, foreign_key: [:prorogated_regulation_id,
  #                                                  :prorogated_regulation_role],
  #                                    class_name: 'BaseRegulation'
end


