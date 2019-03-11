module Api
  module V1
    module Sections
      class GuideSerializer
        include FastJsonapi::ObjectSerializer
        attributes :title, :url
      end
    end
  end
end