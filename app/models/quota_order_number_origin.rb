class QuotaOrderNumberOrigin < ActiveRecord::Base
  self.primary_key = :quota_order_number_origin_sid

  belongs_to :geographical_area
end
