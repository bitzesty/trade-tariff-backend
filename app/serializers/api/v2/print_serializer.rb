module Api
  module V2
    class PrintSerializer
      include FastJsonapi::ObjectSerializer
      attributes :url, :date
    end
  end
end
