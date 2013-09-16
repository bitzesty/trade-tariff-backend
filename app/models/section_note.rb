class SectionNote < Sequel::Model
  plugin :json_serializer
  plugin :active_model
  plugin :time_machine, period_start_column: Sequel.qualify(:section_notes, :validity_start_date),
                        period_end_column:   Sequel.qualify(:section_notes, :validity_end_date)

  many_to_one :section

  def validate
    super

    errors.add(:content, 'cannot be empty') if !content || content.empty?
    errors.add(:section_id, 'cannot be empty') if section_id.blank?
  end
end
