class SectionNote < Sequel::Model
  plugin :json_serializer
  plugin :active_model

  many_to_one :section

  def validate
    super

    errors.add(:content, 'cannot be empty') if !content || content.empty?
  end
end
