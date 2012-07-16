module Model
  module Dateable
    extend ActiveSupport::Concern

    included do
      scope :valid_on, ->(date) { where{(validity_start_date.lte date) &
                                        ((validity_end_date.gte date) |
                                         (validity_end_date.eq nil)
                                        )}
                                }
      scope :valid_between, ->(start_date, end_date) {
                                    where{(validity_start_date.lte start_date) &
                                          ((validity_end_date.gte end_date) |
                                      (validity_end_date.eq nil)
                                    )}
                                  }
    end
  end
end
