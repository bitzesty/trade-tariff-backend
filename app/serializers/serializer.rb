class Serializer < SimpleDelegator
  include ActiveModel::Serializers::JSON

  self.include_root_in_json = false

  def to_json(opts = {})
    as_json(opts).to_json
  end
end
