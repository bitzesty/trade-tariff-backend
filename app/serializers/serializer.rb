class Serializer < SimpleDelegator
  include ActiveModel::Serializers::JSON

  def to_json(opts = {})
    as_json(opts).to_json
  end
end
