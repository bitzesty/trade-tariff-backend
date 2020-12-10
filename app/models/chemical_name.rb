class ChemicalName < Sequel::Model
  many_to_one :chemical

  def validate
    super
    errors.add(:name, 'is missing') if name.blank?
    errors.add(:name, 'must be unique') if ChemicalName.where(name: name).any?
  end

  # A Sequel error is a hash, e.g.: {:cas=>["is missing", "must be unique"]}:Sequel::Model::Errors
  # Call `.validate` or `valid?` on the model instance first, or else `.errors` will be an empty hash
  def stringify_sequel_errors
    errors&.map{ |k, v| v.map{ |err| "`#{self.class.name}.#{k}` #{err}" } }
      .flatten
      .join(' and ')
  end

  def update_with_name(name)
    errors = []
    status = :ok
    begin
      update(name: name)
    rescue Sequel::ValidationFailed
      errors << stringify_sequel_errors
      status = :unprocessable_entity
    end
    [errors, status]
  end
end
