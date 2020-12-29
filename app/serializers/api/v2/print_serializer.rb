module Api
  module V2
    class PrintSerializer
      include JSONAPI::Serializer

      set_type :print

      attributes :url, :date
    end
  end
end
