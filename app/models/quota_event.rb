class QuotaEvent
  EVENTS = %w(balance exhaustion balance critical reopening unblocking unsuspension)

  # Generate SELECT .. UNION from all event types
  def self.for_quota_definition(quota_sid)
    EVENTS.from(1).inject(for_event(EVENTS.first, quota_sid)) { |memo, event_type|
      memo = memo.union(for_event(event_type, quota_sid), from_self: true)
    }.order(Sequel.desc(:occurrence_timestamp))
  end

  def self.last_for(quota_sid)
    event = for_quota_definition(quota_sid).first

    if event.present?
      Object.const_get("Quota#{event[:event_type].capitalize}Event")
    else
      NullObject.new
    end
  end

  private

  def self.for_event(event_type, quota_sid)
    Object.const_get("Quota#{event_type.capitalize}Event").select(:quota_definition_sid,
                                                                  :occurrence_timestamp,
                                                                  Sequel.as(event_type, "event_type"))
                                                          .where(quota_definition_sid: quota_sid)
  end
end
