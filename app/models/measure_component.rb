class MeasureComponent < ActiveRecord::Base
  belongs_to :measure, foreign_key: :measure_sid
end
