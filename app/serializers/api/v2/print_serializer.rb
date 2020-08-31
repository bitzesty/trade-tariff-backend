module Api
  module V2
    class PrintSerializer
      include JSONAPI::Serializer
      attributes :url, :date
    end
  end
end
