module Api
  module V2
    class NullSearchPresenter < ::Api::V2::FuzzySearchPresenter
      def type
        'null_match'
      end
    end
  end
end
