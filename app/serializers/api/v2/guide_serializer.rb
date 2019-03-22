module Api
  module V2
    class GuideSerializer
      include FastJsonapi::ObjectSerializer
      set_type :guide
      attributes :title, :url
    end
  end
end