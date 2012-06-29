class TransmissionComment < ActiveRecord::Base
  self.primary_key = :comment_sid

  belongs_to :language
end
