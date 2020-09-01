module Api
  module V2
    class GuideSerializer
      include JSONAPI::Serializer
      set_type :guide

      set_id :id

      attributes :title, :url
    end
  end
end
