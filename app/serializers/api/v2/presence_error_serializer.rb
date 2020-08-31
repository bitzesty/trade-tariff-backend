module Api
  module V2
    class PresenceErrorSerializer
      include JSONAPI::Serializer

      set_type :presence_error

      set_id :id

      attributes :model_name, :details
    end
  end
end
