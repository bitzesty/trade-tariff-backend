class TransmissionComment < Sequel::Model
  set_primary_key [:comment_sid, :language_id]

  many_to_one :language
end


