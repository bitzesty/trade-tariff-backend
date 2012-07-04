class BaseRegulation < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code


  belongs_to :regulation_group
  has_many :modification_regulations
  belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
                                                            :explicit_abrogation_regulation_id]
  belongs_to :complete_abrogation_regulation, foreign_key: [:complete_abrogation_regulation_role,
                                                            :complete_abrogation_regulation_id]
  belongs_to :antidumping_regulation, foreign_key: [:antidumping_regulation_role,
                                                    :related_antidumping_regulation_id],
                                      class_name: 'BaseRegulation'


  has_many :replacing_regulation_replacements, foreign_key: [:replacing_regulation_role,
                                                             :replacing_regulation_id],
                                               class_name: 'BaseRegulation'

  has_many :replaced_regulation_replacements, foreign_key: [:replaced_regulation_role,
                                                            :replaced_regulation_id],
                                               class_name: 'BaseRegulation'
  has_many :prorogation_regulation_replacements, foreign_key: [:prorogation_regulation_role,
                                                               :prorogation_regulation_id],
                                                 class_name: 'BaseRegulation'
end
