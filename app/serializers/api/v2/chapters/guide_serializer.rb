module Api
  module V1
    module Chapters
      class GuideSerializer
        include FastJsonapi::ObjectSerializer
        set_type :guide
        attributes :title, :url
      end
    end
  end
end