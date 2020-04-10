module Api
  module V2
    module Chemicals
      class ChemicalNameSerializer
        include FastJsonapi::ObjectSerializer

        attributes :name, :chemical_id
      end
    end
  end
end
